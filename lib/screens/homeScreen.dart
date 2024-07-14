import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yiddishconnect/services/auth.dart';
import 'package:yiddishconnect/utils/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0; // Index of the child currently visible
  List<Widget> _screens = [
    HomeScreen(),
    TestWidgetOne(),
    TestWidgetTwo(),
    TestWidgetThree()
  ]; // All children


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}





class TestWidgetOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Widget One'),
    );
  }
}

class TestWidgetTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: 100,
      height: 100,
    );
  }
}

class TestWidgetThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.star,
      size: 50,
      color: Colors.red,
    );
  }
}

