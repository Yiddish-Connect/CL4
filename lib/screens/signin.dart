import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ydtind/screens/signup.dart';
import 'package:ydtind/utils/helpers.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 50),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // The avatar (TODO)
                margin: EdgeInsets.all(20),
                constraints: BoxConstraints(minHeight: 200),
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.red, // Set the color of the block
                        width: 180, // Set the width of the block
                        height: 180, // Set the height of the block
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                // The text
                margin: const EdgeInsets.all(20.0),
                constraints: BoxConstraints(minHeight: 100),
                child: Center(
                  child: Text(
                    "Let's meeting new people around you",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              Container(
                // The 2 buttons
                margin: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // The 'Login with Email' button
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                          // Continue => Anonymous mode (TODO)
                          onPressed: () {
                            toast(context, "Login with Email");
                          },
                          child: Text("Login with Email")),
                    ),
                    // The 'Login with Google' button
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        // Sign in => SignInPage
                        onPressed: () {
                          toast(context, "Login with Google");
                        },
                        child: Text("Login with Google"),
                      ),
                    ),
                    // The 'Don't have an account? Sign Up'
                    Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              text: "Don't have an account?",
                              children: [
                                TextSpan(
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black),
                                    text: "Sign Up",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // TODO
                                      })
                              ]),
                        ))
                  ],
                ),
              )
            ]),
      ),
    );
    ;
  }
}
