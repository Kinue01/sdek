import 'package:clientapp/view/client_packages_page/client_packages_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeComponent();
  }
}

class HomeComponent extends StatefulWidget with GetItStatefulWidgetMixin {
  HomeComponent({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeComponent> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Домашняя страница'),
      ),
      body: const Center(
        child: ClientPackagesPage() 
      )
    );
  }
}
