import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yiddishconnect/screens/dev_signin_signup/dev_signin.dart';
import 'package:yiddishconnect/screens/dev_signin_signup/dev_signup.dart';
import 'package:yiddishconnect/screens/email/emailSignIn.dart';
import 'package:yiddishconnect/screens/email/emailSignUp.dart';
import 'package:yiddishconnect/screens/phone/phoneAuth.dart';
import 'package:yiddishconnect/services/auth.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import 'dev_signin_signup/dev_home.dart';

class AuthScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 50),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                "Let's meet new people around you",
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
                // Email Sign-in
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.onPrimary),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EmailSignInScreen()));
                          },
                          child: Text("Login with Email")
                        // Don't need to specify the style here.
                        // The default style here is inherited from ElevatedButton, which will automatically looks for labelMedium
                      ),
                    ),
                  ),
                ),
                // Phone Sign-in
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary, foregroundColor: Theme.of(context).colorScheme.onSecondary),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneAuthScreen()));
                          },
                          child: Text("Login with Phone")
                        // Don't need to specify the style here.
                        // The default style here is inherited from ElevatedButton, which will automatically looks for labelMedium
                      ),
                    ),
                  ),
                ),
                // Social Media Sign-in
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      child: (Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.macOS) ? _buildAppleButton(context) : _buildGoogleButton(context)
                      ),
                    ),
                  ),
                // The 'Don't have an account? Create one with Email'
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: RichText(
                      text: TextSpan(style: Theme.of(context).textTheme.labelSmall, text: "Don't have an account? ", children: [
                        TextSpan(
                            style: Theme.of(context).textTheme.labelMedium,
                            text: "Create one with Email",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => EmailSignUpScreen()
                                ));
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

  Widget _buildGoogleButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.surface, foregroundColor: Theme.of(context).colorScheme.onSurface),
        onPressed: () async {
          try {
            User? user = await _auth.signInWithGoogle();
            if (user != null) {
              toast(context, "Successfully signed in with Google");
              Navigator.push(context, MaterialPageRoute(builder: (context) => DevHome()));
            } else {
              toast(context, "Something went wrong (null)");
            }
          } catch (e) {
            toast(context, e.toString());
          }
        },
        child: Text("Login with Google")
      // Don't need to specify the style here.
      // The default style here is inherited from ElevatedButton, which will automatically looks for labelMedium
    );
  }

  Widget _buildAppleButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.onPrimary),
        onPressed: () {
          // TODO: Apple Login
          toast(context, "TODO: Login with Apple");
        },
        child: Text("Login with Apple")
      // Don't need to specify the style here.
      // The default style here is inherited from ElevatedButton, which will automatically looks for labelMedium
    );
  }
}
