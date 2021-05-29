// @dart=2.9

import 'package:flutter/material.dart';
import 'package:queryapp/Utils/custom_colors.dart';
import 'package:queryapp/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VG Sales Analysis',
      home: MyHomePage(),
    );
  }
}