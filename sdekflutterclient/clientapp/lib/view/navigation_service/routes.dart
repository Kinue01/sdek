import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  static void configRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return;
    });

    router.define("/", handler: );


  }
}