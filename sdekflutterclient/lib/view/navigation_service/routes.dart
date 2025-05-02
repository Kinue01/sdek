import 'package:clientapp/view/navigation_service/route_handlers.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  static void configRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return;
    });

    router.define("/", handler: rootHandler);
    router.define("/send_package", handler: sendPackageHandler);
    router.define("/track_package", handler: trackPackageHandler);
    router.define("/home", handler: homeHandler);
    router.define("/details", handler: detailsHandler);
    router.define("/register", handler: registerHandler);
  }
}