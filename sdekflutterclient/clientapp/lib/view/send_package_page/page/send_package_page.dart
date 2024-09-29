import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SendPackagePage extends StatelessWidget {
  const SendPackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SendPackageView();
  }
}

class SendPackageView extends StatefulWidget with GetItStatefulWidgetMixin {
  SendPackageView({super.key});

  @override
  State<StatefulWidget> createState() {
    return SendPackageViewState();
  }
}

class SendPackageViewState extends State<SendPackageView> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Package')),
      body: const Center(child: Text('Send Package Form Here')),
    );
  }
}