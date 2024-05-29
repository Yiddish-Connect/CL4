import 'package:flutter/material.dart';

class LoadingScreen3 extends StatefulWidget {
  @override
  _LoadingScreen3State createState() => _LoadingScreen3State();
}

class _LoadingScreen3State extends State<LoadingScreen3> {
  @override
  void initState() {
    super.initState();
    print("LoadingScreen3 initState");
    Future.delayed(Duration(seconds: 5), () {
      print("LoadingScreen3 delay complete");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/1. Spash Screen (3).png'),
      ),
    );
  }
}
