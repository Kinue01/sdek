import 'dart:async';
import 'dart:convert';

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
  late TrackPackageController? controller;
  late MapController _mapController;

  final List<LatLng> _mapPoints = [];
  final List<String> _transPos = [];

  @override
  void initState() {
    controller = get<TrackPackageController>();
    controller?.init();
    Future.delayed(Duration.zero, () async => {
      await get<TrackPackageController>().getClientPackages()
    });
    _mapController = MapController();

    controller!.streamController.stream.listen((ev) {
      setState(() {
        _mapPoints.clear();
        for (var pos in ev) {
          _mapPoints.add(LatLng(pos.lat, pos.lon));
          _transPos.add(pos.transport_id);
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
        child: Column(
          children: [
            Image.asset('assets/icons/map_point.png'),
            Text(
                controller!.packages.value.firstWhere((pack) { return pack.package_deliveryperson?.person_transport?.transport_id.toString() == _transPos[index]; }).package_uuid.toString()
            )
          ],
        ),
        width: 50,
        height: 50,
        alignment: Alignment.center,
      ),
    );
  }

  @override
  void dispose() {
    controller = null;
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