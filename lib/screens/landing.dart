import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yiddishconnect/services/auth.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import 'package:yiddishconnect/widgets/yd_animated_curve.dart';
import '../widgets/yd_label.dart';
import 'authentication.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Flexible spacer 50 px
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: 50,
                ),
              ),
              // Avatar with animated curve
              Container(
                width: 500 + 20,
                height: 300 + 20,
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
              // "Make friends with people like you"
              Container(
                margin: const EdgeInsets.all(20.0),
                constraints: BoxConstraints(minHeight: 100),
                child: Center(
                  child: Text(
                    "Make friends with people like you",
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
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FractionallySizedBox(
                          widthFactor: 0.6,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                            // Continue => Anonymous mode
                            onPressed: () async {
                              try {
                                User? user = await AuthService().signInAnonymously();
                                if (user != null) {
                                  context.go("/");
                                } else {
                                  toast(context, "Something went wrong (null)");
                                }
                              } catch (e) {
                                toast(context, e.toString());
                              }
                            },
                            child: Text("Continue"),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FractionallySizedBox(
                          widthFactor: 0.6,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              foregroundColor: Theme.of(context).colorScheme.onSurface,
                            ),
                            // Sign in => SignInPage
                            onPressed: () {
                              context.go("/auth");
                            },
                            child: Text("Login"),
                          ),
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
    );
  }
}
