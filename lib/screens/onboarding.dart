import 'package:flutter/material.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import 'authentication.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 50),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              // The avatar (TODO)
              constraints: BoxConstraints(minHeight: 200),
              margin: EdgeInsets.all(20),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      color: Colors.blue, // Set the color of the block
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
                            onPressed: () {
                              toast(context, "TODO: anonymous mode???");
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen()));
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
