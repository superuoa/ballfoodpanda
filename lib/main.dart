import 'package:flutter/material.dart';
import 'package:ballfoodpanda/screen/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.brown,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white //here you can give the text color
              )),
      title: 'Food Panda',
      home: Home(),
    );
  }
}
