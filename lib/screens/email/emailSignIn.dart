import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import '../../services/auth.dart';

class EmailSignInScreen extends StatefulWidget {
  @override
  _EmailSignInScreenState createState() => _EmailSignInScreenState();
}

class _EmailSignInScreenState extends State<EmailSignInScreen> {
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
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(30),
                  child: Text("Register with Email & password", style: Theme.of(context).textTheme.titleLarge),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: SizedBox(
                    height: 80,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: SizedBox(
                    height: 80,
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(30),
                  child: SizedBox(
                    height: 50,
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.onPrimary),
                        onPressed: () async {
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          User? user = await _auth.registerWithEmailAndPassword(email, password);
                          if (user != null) {
                            toast(context, "Successfully signed in");
                          } else {
                            toast(context, "Something went wrong");
                          }
                        },
                        child: Text('Register'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
