import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yiddishconnect/services/firebaseAuthentication.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import '../../widgets/yd_animated_curve.dart';
import '../../widgets/yd_label.dart';
import 'package:yiddishconnect/widgets/ErrorHandlers.dart';
import 'dev_signin_signup/dev_home.dart';
import 'package:yiddishconnect/services/firestoreService.dart';

/// This screen when user clicks on "Login" in the landing page
/// The authentication main screen showing all 3 methods: phone, email, Google/Apple
/// Route: 'auth'
class AuthScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Spacer 50 px
                      SizedBox(
                        height: 50,
                      ),
                      // Avatar
                      Container(
                        width: constraints.maxWidth * 0.8,
                        height: constraints.maxHeight * 0.4,
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Stack(
                            children: [
                              // The animated curve
                              Align(
                                alignment: Alignment.center,
                                child: AnimatedCurve(),
                              ),
                              // The user avatar 1
                              Positioned(
                                top: 100,
                                left: 40,
                                child: Opacity(
                                  opacity: 0.8,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage('https://picsum.photos/200'),
                                    radius: 50,
                                  ),
                                ),
                              ),
                              // The user avatar 2
                              Positioned(
                                top: 10,
                                right: 40,
                                child: Opacity(
                                  opacity: 0.8,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage('https://picsum.photos/200'),
                                    radius: 50,
                                  ),
                                ),
                              ),
                              // "Intermediate"
                              Positioned(
                                top: 20,
                                left: 60,
                                child: Label(
                                  borderColor: Theme.of(context).colorScheme.primary,
                                  backgroundColor: Theme.of(context).colorScheme.background,
                                  opacity: 0.7,
                                  text: "Intermediate",
                                  height: 30,
                                  width: 100,
                                ),
                              ),
                              // "Proficient"
                              Positioned(
                                bottom: 120,
                                right: 60,
                                child: Label(
                                  borderColor: Theme.of(context).colorScheme.secondary,
                                  backgroundColor: Theme.of(context).colorScheme.background,
                                  opacity: 0.7,
                                  text: "Proficient",
                                  height: 30,
                                  width: 100,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // "Let's meet new people around you"
                      Container(
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
                      // Buttons
                      Container(
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
                                  widthFactor: 0.7,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                    onPressed: () {
                                      context.go("/auth/email/sign-in");
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.email,
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          size: 30,
                                        ),
                                        SizedBox(width: 8.0),
                                        Text(
                                          "Login with Email",
                                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                            color: Theme.of(context).colorScheme.onPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                  widthFactor: 0.7,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.secondary,
                                      foregroundColor: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                    onPressed: () {
                                      context.go("/auth/phone");
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.phone_android,
                                          color: Theme.of(context).colorScheme.onSecondary,
                                          size: 30,
                                        ),
                                        SizedBox(width: 8.0),
                                        Text(
                                          "Login with Phone",
                                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                            color: Theme.of(context).colorScheme.onSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                  widthFactor: 0.7,
                                  child: (Theme.of(context).platform == TargetPlatform.iOS ||
                                      Theme.of(context).platform == TargetPlatform.macOS)
                                      ? _buildAppleButton(context)
                                      : _buildGoogleButton(context),
                                ),
                              ),
                            ),
                            // The 'Don't have an account? Create one with Email'
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.labelSmall,
                                  text: "Don't have an account? ",
                                  children: [
                                    TextSpan(
                                      style: Theme.of(context).textTheme.labelMedium,
                                      text: "Create one with Email",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          context.go("/auth/email/sign-up");
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGoogleButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFF2F2F2),
        foregroundColor: Color(0xFF1F1F1F),
      ),
      onPressed: () async {
        if (!context.mounted) {
          throw Exception("Google Login Button: context is not mounted!!");
        }
        try {
          User? user = await _auth.signInWithGoogle();
          if (user != null) {
            toast(context, "Successfully signed in with Google");
            //create a new user in the database
            FirestoreService().createUserDocument(user.uid, user.displayName ?? user.uid);
            context.go("/");
          } else {
            toast(context, "Something went wrong (null)");
          }
        } on FirebaseAuthException catch (e) {
          googleError(context, e.code.toString());
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/google_icon@2x.png'), // Path to your Google icon file
            height: 40.0,
            width: 40.0,
          ),
          SizedBox(width: 8.0),
          Text(
            "Login with Google",
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildAppleButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF131314),
        foregroundColor: Color(0xFFE3E3E3),
      ),
      onPressed: () {
        // TODO: Apple Login
        toast(context, "TODO: Login with Apple");
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/apple_icon@2x.png'), // Path to your Google icon file
            height: 40.0,
            width: 40.0,
          ),
          SizedBox(width: 8.0),
          Text(
            "Login with Apple",
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}