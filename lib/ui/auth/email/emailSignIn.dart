import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:yiddishconnect/utils/helpers.dart';

import '../../../services/firebaseAuthentication.dart';
import '../../../widgets/ErrorHandlers.dart';

import 'package:yiddishconnect/services/firestoreService.dart';
/// The Email sign-in screen using Firebase Authentication (Email)
/// Route: '/auth/email/sign-in'
class EmailSignInScreen extends StatefulWidget {
  @override
  State<EmailSignInScreen> createState() => _EmailSignInScreenState();
}

class _EmailSignInScreenState extends State<EmailSignInScreen> {
  final AuthService _auth = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  static const passwordReqirements =
      "Password must include:\n1 special character & 1 capital letter";
  final passwordValidator = ValidationBuilder()
      .minLength(10)
      .maxLength(50)
      .regExp(new RegExp("[\p{Lu}\p{Lt}]"), passwordReqirements)
      .regExp(new RegExp("[^A-Za-z0-9]"), passwordReqirements)
      .build();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Login'),
          ),
          body: Padding(
            padding: EdgeInsets.all(32.0), // 16 + 16
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(30),
                      child: Text("Enter your Email & password",
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: SizedBox(
                        height: 80,
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email'),
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
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(5),
                        child: RichText(
                            text: TextSpan(
                                text: "Forget your password? ",
                                style: Theme.of(context).textTheme.labelMedium,
                                children: [
                              TextSpan(
                                  text: "Reset",
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      String email = _emailController.text;
                                      _auth.sendPasswordResetEmailTo(email);
                                      toast(context,
                                          "We have sent a password recovery link to $email");
                                    })
                            ]))),
                    Container(
                      padding: EdgeInsets.all(30),
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

                              //validate first then go to firebase
                              final form = formKey.currentState!;

                              try {
                                if (form.validate()) {
                                  try {
                                    User? user =
                                        await _auth.signInWithEmailAndPassword(
                                            email, password);
                                    if (user != null) {
                                      toast(context,
                                          "Successfully signed in with Email");
                                      //create user document in Firestore
                                      //since I already had an account with the email so I have to call the function
                                      //to create the user document in Firestore, in the future, we can remove this and only
                                      //create the user document when the user signs up
                                      FirestoreService()
                                          .createUserDocument(_auth.getUser()!.uid, _auth.getUser()!.displayName ?? _auth.getUser()!.uid);
                                      context.go("/");

                                    } else {
                                      toast(context,
                                          "Something went wrong (null)");
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    emailError(context, e.code);
                                  }
                                } else {
                                  emailError(context, "invalid-email");
                                }
                              } catch (e) {
                                toast(context, e.toString());
                              }
                            },
                            child: Text('Login'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
