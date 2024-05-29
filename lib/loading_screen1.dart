import 'package:flutter/material.dart';

class LoadingScreen1 extends StatefulWidget {
  @override
  _LoadingScreen1State createState() => _LoadingScreen1State();
}

class _LoadingScreen1State extends State<LoadingScreen1> {
  @override
  void initState() {
    super.initState();
    print("LoadingScreen1 initState");
    Future.delayed(Duration(seconds: 5), () {
      print("LoadingScreen1 delay complete");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/1. Spash Screen (1).jpg'),
      ),
    );
  }
}
