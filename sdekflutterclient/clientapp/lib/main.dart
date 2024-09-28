import 'package:clientapp/inject.dart';
import 'package:clientapp/view/application.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initGetIt();
  runApp(const Application());
}