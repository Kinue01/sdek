import 'package:clientapp/view/navigation_service/FluroApp.dart';
import 'package:clientapp/view/navigation_service/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<StatefulWidget> createState() {
    return ApplicationState();
  }
}

class ApplicationState extends State<Application> {
  ApplicationState() {
    final router = FluroRouter();
    Routes.configRoutes(router);
    FluroApp.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Package Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: FluroApp.router.generator,
    );
  }
}