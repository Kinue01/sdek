import 'package:clientapp/view/application.dart';
import 'package:clientapp/view/injector.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const Application());
}