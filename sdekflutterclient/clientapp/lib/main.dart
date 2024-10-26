import 'package:clientapp/inject.dart';
import 'package:clientapp/view/application.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initGetIt();
  runApp(const Application());
}