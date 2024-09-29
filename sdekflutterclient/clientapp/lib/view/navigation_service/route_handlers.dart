import 'package:clientapp/view/send_package_page/page/send_package_page.dart';
import 'package:clientapp/view/track_package_page/page/track_package_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../home_page/view/home_view.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return const HomePage();
    });

var sendPackageHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const SendPackagePage();
  });

var trackPackageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return const TrackPackagePage();
    });