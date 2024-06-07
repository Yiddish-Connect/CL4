import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ydtind/screens/dev_signin_signup/dev_signin.dart';
import 'package:ydtind/screens/dev_signin_signup/dev_signup.dart';
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
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              ),
              Container(
                // The 2 buttons
                margin: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary),
                            onPressed: () {
                              // TODO: Email sign-in page
                              // Below is a demo sign-in page for development
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DevSignInPage()));
                            },
                            child: Text("Login with Email")),
                        // Don't need to specify the style here.
                        // The default style here is inherited from ElevatedButton, which will automatically looks for labelMedium
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onSurface),
                          onPressed: () {
                            toast(context, "TODO: Login with Google");
                          },
                          child: Text("Login with Google"),
                          // Don't need to specify the style here.
                          // The default style here is inherited from ElevatedButton, which will automatically looks for labelMedium
                        ),
                      ),
                    ),
                    // The 'Don't have an account? Sign Up'
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: RichText(
                          text: TextSpan(
                              style: Theme.of(context).textTheme.labelSmall,
                              text: "Don't have an account?",
                              children: [
                                TextSpan(
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                    text: "Sign Up",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // TODO: Email sign-up (multiple screens)
                                        // Below is a demo sign-in page for development
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => DevSignUpPage()));
                                      })
                              ]),
                        ))
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
