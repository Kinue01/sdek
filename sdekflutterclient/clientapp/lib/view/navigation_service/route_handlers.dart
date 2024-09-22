import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../home_page/view/home_view.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return const HomeComponent();
    });