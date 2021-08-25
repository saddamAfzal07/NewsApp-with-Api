import 'package:flutter/material.dart';
import 'package:news_app/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News_App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: home(),
    );
  }
}
