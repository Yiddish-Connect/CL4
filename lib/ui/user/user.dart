import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    print("User-Screen build()");
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO: UserScreen"),
      ),
      body: Placeholder(),
    );
  }
}

