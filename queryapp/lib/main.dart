import 'package:flutter/material.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: MyHomePage(),
    );
  }
}