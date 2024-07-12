import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../utils/helpers.dart';

class DevSignUpPage extends StatefulWidget {
  @override
  _DevSignUpPageState createState() => _DevSignUpPageState();
}

class _DevSignUpPageState extends State<DevSignUpPage> {
  final AuthService _auth = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;
                try {
                  User? user = await _auth.registerWithEmailAndPassword(email, password);
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Successfully signed up (dev)"),
                    ));
                  } else {
                    toast(context, 'Something went wrong (null)');
                  }
                } catch (e) {
                  toast(context, e.toString());
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
