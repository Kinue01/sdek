import 'package:clientapp/view/client_package_details/client_package_details.dart';
import 'package:clientapp/view/login_page/view/login_page.dart';
import 'package:clientapp/view/main_page/main_page.dart';
import 'package:clientapp/view/packages_page/packages_page.dart';
import 'package:clientapp/view/register_page/register_view.dart';
import 'package:clientapp/view/send_package_page/page/send_package_page.dart';
import 'package:clientapp/view/track_package_page/page/track_package_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return const LoginPage();
    });

var sendPackageHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const SendPackagePage();
  });

var trackPackageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return const TrackPackagePage();
    });

var homeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return const MainPage();
    });

var detailsHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const ClientPackageDetails();
  });

var registerHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return const RegisterPage();
    }
);

var packagesHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return const PackagesPage();
    }
);