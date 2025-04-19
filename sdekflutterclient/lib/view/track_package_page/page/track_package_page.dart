import 'dart:convert';
import 'dart:math';

import 'package:clientapp/domain/model/TransportPosition.dart';
import 'package:clientapp/view/track_package_page/controller/track_package_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:latlong2/latlong.dart';

class TrackPackagePage extends StatelessWidget {
  const TrackPackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TrackPackageView();
  }
}

class TrackPackageView extends StatefulWidget with GetItStatefulWidgetMixin {
  TrackPackageView({super.key});

  @override
  State<StatefulWidget> createState() {
    return TrackPackageViewState();
  }
}

class TrackPackageViewState extends State<TrackPackageView> with GetItStateMixin {
  late TrackPackageController controller;
  late MapController _mapController;

  final List<LatLng> _mapPoints = [];

  @override
  void initState() {
    controller = get<TrackPackageController>();
    Future.delayed(Duration.zero, () async => {
      await get<TrackPackageController>().getClientPackages()
    });
    _mapController = MapController();
    controller.channel.stream.listen((ev) {
      final res = json.decode(ev).cast<dynamic>().toList();
      final poses = res.map((e) => TransportPosition.fromMap(e)).toList();
      var posesToShow = List<TransportPosition>.empty(growable: true);

      for (var p in poses) {
        for (var pack in controller.packages.value) {
          if (pack.package_deliveryperson?.person_transport?.transport_id.toString() == p.transport_id) {
            posesToShow.add(p);
          }
        }
      }

      setState(() {
        _mapPoints.clear();
        for (var pos in posesToShow) {
          _mapPoints.add(LatLng(pos.lat, pos.lon));
        }
      });
    });

    super.initState();
  }

  List<Marker> _getMarkers() {
    return List.generate(
      _mapPoints.length,
          (index) => Marker(
        point: _mapPoints[index],
        child: Image.asset('assets/icons/map_point.png'),
        width: 50,
        height: 50,
        alignment: Alignment.center,
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Отследить посылку')),
      body: FlutterMap(mapController: _mapController,
          options: const MapOptions(
            initialZoom: 5
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.sdek',
            ),
            MarkerLayer(
              markers: _getMarkers()
            )
          ]
      )
    );
  }
}