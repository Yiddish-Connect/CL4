import 'package:flutter/material.dart';

class LoadingScreen2 extends StatefulWidget {
  @override
  _LoadingScreen2State createState() => _LoadingScreen2State();
}

class _LoadingScreen2State extends State<LoadingScreen2> {
  @override
  void initState() {
    super.initState();
    print("LoadingScreen2 initState");
    Future.delayed(Duration(seconds: 5), () {
      print("LoadingScreen2 delay complete");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/1. Spash Screen (2).png'),
      ),
    );
  }
}
