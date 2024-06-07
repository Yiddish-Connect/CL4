import 'package:flutter/material.dart';

import '../../services/auth.dart';

class DevSignUpPage extends StatefulWidget {
  @override
  _DevSignUpPageState createState() => _DevSignUpPageState();
}

class _DevSignUpPageState extends State<DevSignUpPage> {
  final AuthService _auth = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
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
                dynamic result =
                await _auth.registerWithEmailAndPassword(email, password);
                if (result != null) {
                  print('Signed up');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Signup Successful!!!"),
                  ));
                } else {
                  print('Error signing up');
                  print(result);
                }
              },
              child: Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}