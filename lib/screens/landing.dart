import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yiddishconnect/services/auth.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import 'package:yiddishconnect/widgets/yd_animated_curve.dart';
import 'authentication.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              // The avatar (TODO)
              padding: EdgeInsets.all(10),
              child: Center(
                child: Stack(
                  children: [
                    AnimatedCurve(),
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
                "Make friends with people like you",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              )),
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
                      child: FractionallySizedBox(
                        widthFactor: 0.6,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.onPrimary),
                            // Continue => Anonymous mode (TODO)
                            onPressed: () async {
                              try {
                                User? user = await AuthService().signInAnonymously();
                                if (user != null) {
                                  context.go("/home");
                                } else {
                                  toast(context, "Something went wrong (null)");
                                }
                              } catch (e) {
                                toast(context, e.toString());
                              }
                            },
                            child: Text("Continue")
                            // Don't need to specify the style here.
                            // The default style here is inherited from ElevatedButton, which will automatically looks for labelMedium
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
                          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.surface, foregroundColor: Theme.of(context).colorScheme.onSurface),
                          // Sign in => SignInPage
                          onPressed: () {
                            context.go("/auth");
                          },
                          child: Text("Login"),
                          // Don't need to specify the style here.
                          // The default style here is inherited from ElevatedButton, which will automatically looks for labelMedium
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
