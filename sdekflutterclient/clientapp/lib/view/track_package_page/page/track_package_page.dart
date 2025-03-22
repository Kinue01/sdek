import 'package:clientapp/view/track_package_page/controller/track_package_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

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

  @override
  void initState() {
    controller = get<TrackPackageController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Отследить посылку')),
      body: StreamBuilder(stream: controller.channel.stream, builder: (context, snapshot) {
        return Text(snapshot.data);
      })
    );
  }
}