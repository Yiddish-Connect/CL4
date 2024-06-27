import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import '../../services/auth.dart';
import '../../widgets/yd_multi_steps.dart';
import '../dev_signin_signup/dev_home.dart';

class EmailSignUpScreen extends StatelessWidget {
  const EmailSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmailProvider(),
      child: MultiSteps(
        steps: [
          OneStep(
            title: "Step 1: Enter your Email and password",
            builder: (callback) => _Step1(action: callback),
          ),
          OneStep(
            title: "Step 2: Verify your Email address",
            builder: (callback) => _Step2(action: callback),
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
class _Step1 extends ActionWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  _Step1({super.key, required super.action});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: SizedBox(
              height: 80,
              child: TextField(
                controller: _passwordController,
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
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.onPrimary),
                  onPressed: () async {
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    try {
                      Provider.of<EmailProvider>(context, listen: false).email = email; // store the email in EmailProvider
                      User? user = await _auth.registerWithEmailAndPassword(email, password);
                      if (user != null) {
                        await user.sendEmailVerification();
                        toast(context, "A verification email has been sent to your address");
                        action();
                      } else {
                        toast(context, "Something went wrong (null)");
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
    );
  }
}

// Step 2: Ask user to click verification link
class _Step2 extends ActionWidget {
  _Step2({super.key, required super.action});

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
                      text: TextSpan(text: "Didn't receive the email?", style: Theme.of(context).textTheme.labelMedium, children: [
                    TextSpan(
                        text: "Resend",
                        style: Theme.of(context).textTheme.labelMedium,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            try {
                              await _auth.getUser()?.sendEmailVerification();
                              toast(context, "We have resent another verification email to ${emailProvider.email}");
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
                          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.onPrimary),
                          onPressed: () {
                            if (_auth.getUser() == null) {
                              toast(context, "Verification Failed");
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DevHome()));
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
