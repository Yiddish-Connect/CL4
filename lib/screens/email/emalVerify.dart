import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yiddishconnect/utils/helpers.dart';

class EmailVerifyScreen extends StatelessWidget {
  const EmailVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  "A verification Email has been sent to your address",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(text: TextSpan(
                  text: "Didn't receive the email?",
                  style: Theme.of(context).textTheme.labelMedium,
                  children: [
                    TextSpan(
                      text: "Resend",
                      style: Theme.of(context).textTheme.labelMedium,
                      recognizer: TapGestureRecognizer()..onTap = () {
                          toast(context, "TODO");
                      }
                    )
                  ]
                ))
              )
            ],
          ),
        )
      )
    );
  }
}
