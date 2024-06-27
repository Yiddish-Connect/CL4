import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import '../../services/auth.dart';
import '../dev_signin_signup/dev_home.dart';

class EmailSignInScreen extends StatefulWidget {
  @override
  State<EmailSignInScreen> createState() => _EmailSignInScreenState();
}

class _EmailSignInScreenState extends State<EmailSignInScreen> {
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
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(32.0), // 16 + 16
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(30),
                  child: Text("Enter your Email & password", style: Theme.of(context).textTheme.titleLarge),
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
                    padding: EdgeInsets.all(5),
                    child: RichText(text: TextSpan(
                        text: "Forget your password? ",
                        style: Theme.of(context).textTheme.labelMedium,
                        children: [
                          TextSpan(
                              text: "Reset",
                              style: Theme.of(context).textTheme.labelMedium,
                              recognizer: TapGestureRecognizer()..onTap = () {
                                String email = _emailController.text;
                                _auth.sendPasswordResetEmailTo(email);
                                toast(context, "We have sent a password recovery link to $email");
                              }
                          )
                        ]
                    ))
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
                          try {
                            User? user = await _auth.signInWithEmailAndPassword(email, password);
                            if (user != null) {
                              toast(context, "Successfully signed in with Email");
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DevHome()));
                            } else {
                              toast(context, "Something went wrong (null)");
                            }
                          } catch (e) {
                            toast(context, e.toString());
                          }
                        },
                        child: Text('Login'),
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
