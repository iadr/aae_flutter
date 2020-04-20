import 'package:flutter/material.dart';
import 'package:flutter_login_screens/login_screen_2.dart';
// import 'package:flutter_login_screens/login_screen_3.dart';
// import 'package:flutter_login_screens/misc/slide_list_view.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Login Screen 1',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: LoginScreen2(
            backgroundColor1: Color(0xFF444152),
            backgroundColor2: Color(0xFF6f6c7d),
            highlightColor: Color(0xfff65aa3),
            foregroundColor: Colors.white,
            logo: new AssetImage("assets/images/full-bloom.png"),
          ),
        ));
  }
}
