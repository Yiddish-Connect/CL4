import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yiddishconnect/utils/helpers.dart';

import '../../../services/firebaseAuthentication.dart';
import '../../../widgets/ErrorHandlers.dart';
import '../../../widgets/yd_multi_steps.dart';

/// The Email sign-up screen using Firebase Authentication (Email)
/// Route: '/auth/email/sign-up'
class EmailSignUpScreen extends StatelessWidget {
  const EmailSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmailProvider(),
      child: MultiSteps(
        hasButton: false,
        hasProgress: true,
        enableSwipe: false,
        enableBack: false,
        title: "Email Register",
        steps: [
          OneStep(
            title: "Step 1: Enter your Email and password",
            builder: (prev, next) => _Step1(action: next),
          ),
          OneStep(
            title: "Step 2: Verify your Email address",
            builder: (prev, next) => _Step2(action: next),
          ),
        ],
      ),
    );
  }
}

class EmailProvider extends ChangeNotifier {
  String _email = "";

  String get email => _email;

  set email(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }
}

// Step 1: Ask user for email & password
class _Step1 extends StatefulWidget {
  final void Function() action;

  _Step1({super.key, required this.action});

  @override
  State<_Step1> createState() => _Step1State();
}

class _Step1State extends State<_Step1> {
  final TextEditingController _emailController = TextEditingController();
  //shatoria
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  static const passwordReqirements =
      "Password must include:\n1 special character & 1 capital letter";
  final passwordValidator = ValidationBuilder()
      .minLength(10)
      .maxLength(50)
      .regExp(new RegExp("[\p{Lu}\p{Lt}]"), passwordReqirements)
      .regExp(new RegExp("[^A-Za-z0-9]"), passwordReqirements)
      .build();

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          alignment: Alignment.center,
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: SizedBox(
                  height: 80,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'), //shatoria,
                    autofillHints: [AutofillHints.email],
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? "Enter a valid email"
                            : null,
                    onChanged: (value) {
                      setState(() {});
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: SizedBox(
                  height: 80,
                  child: TextFormField(
                    controller: _passwordController,
                    validator: passwordValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 40),
                child: SizedBox(
                  height: 50,
                  child: FractionallySizedBox(
                    widthFactor: 0.6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary),
                      onPressed: () async {
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        try {
                          //validate first then go to firebase
                          final form = formKey.currentState!;

                          if (form.validate()) {
                            try {
                              Provider.of<EmailProvider>(context, listen: false)
                                      .email =
                                  email; // store the email in EmailProvider
                              User? user =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password);
                              if (user != null) {
                                await user.sendEmailVerification();
                                toast(context,
                                    "A verification email has been sent to your address");
                                widget.action();
                              } else {
                                toast(context, "Something went wrong (null)");
                              }
                            } catch (e) {
                              emailError(context, "invalid-email");
                            }
                          } else {
                            emailError(context, "invalid-email");
                          }
                        } catch (e) {
                          toast(context, e.toString());
                        }
                      },
                      child: Text('Register'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

// Step 2: Ask user to click verification link
class _Step2 extends StatelessWidget {
  final void Function() action;
  _Step2({super.key, required this.action});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Consumer<EmailProvider>(
      builder: (context, emailProvider, child) {
        return Container(
          padding: EdgeInsets.all(30),
          constraints: BoxConstraints(maxWidth: 600),
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  "A verification Email has been sent to ${emailProvider.email}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                  padding: EdgeInsets.all(5),
                  child: RichText(
                      text: TextSpan(
                          text: "Didn't receive the email?",
                          style: Theme.of(context).textTheme.labelMedium,
                          children: [
                        TextSpan(
                            text: "Resend",
                            style: Theme.of(context).textTheme.labelMedium,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                try {
                                  await _auth
                                      .getUser()
                                      ?.sendEmailVerification();
                                  toast(context,
                                      "We have resent another verification email to ${emailProvider.email}");
                                } catch (e) {
                                  toast(context, e.toString());
                                }
                              })
                      ]))),
              Container(
                  padding: EdgeInsets.only(top: 40),
                  child: SizedBox(
                    height: 50,
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary),
                          onPressed: () {
                            if (_auth.getUser() == null) {
                              toast(context, "Verification Failed");
                            } else {
                              context.go("/");
                            }
                          },
                          child: Text("I have verified my Email")),
                    ),
                  ))
            ],
          ),
        );
      },
    );
  }
}
