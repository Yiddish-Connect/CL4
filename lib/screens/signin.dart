import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ydtind/screens/signup.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // The avatar
                constraints: BoxConstraints(minHeight: 200),
                margin: EdgeInsets.all(20),
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
                height: 100,
                child: Center(
                  child: Text("Let's meeting new people around you"),
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
                            // TODO
                          },
                          child: Text("Login with Email")),
                    ),
                    // The 'Login with Google' button
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        // Sign in => SignInPage
                        onPressed: () {
                          // TODO
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
