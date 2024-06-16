import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import '../../services/auth.dart';
import '../dev_signin_signup/dev_home.dart';

class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key});

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  final PageController _pageController = PageController();
  int _page = 0;
  int _size = 2;
  Duration _duration = Duration(milliseconds: 300);

  void _next() {
    if (_page < _size - 1 && _page > -1) {
      _pageController.animateToPage(_page + 1, duration: _duration, curve: Curves.easeInOut);
      _page ++;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _page = index;
          });
        },
        children: [
          AuthStep(
            title: "Step 1: Enter your Email and password",
            child: EmailSignUpInput(next: _next,),
            onNext: _next,
          ),
          AuthStep(
            title: "Step 2: Verify your email",
            child: EmailSignUpVerification(),
            onNext: _next,
          ),
        ],
      )
    );
  }
}

class AuthStep extends StatelessWidget {
  final String title;
  final Widget child;
  final void Function() onNext;

  const AuthStep({super.key, required this.title, required this.child, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(30),
              child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
            ),
            Container(
              child: child
            )
          ],
        )
      ),

    );
  }
}

// Widget for AuthStep 01: Ask user for email & password
class EmailSignUpInput extends StatelessWidget {
  final void Function() next;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  EmailSignUpInput({super.key, required this.next});

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
            padding: EdgeInsets.only(top: 50),
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
                      User? user = await _auth.registerWithEmailAndPassword(email, password);
                      if (user != null) {
                        await user.sendEmailVerification();
                        toast(context, "A verification email has been sent to your address");
                        next();
                      } else {
                        toast(context, "Something went wrong (null)");
                      }
                    } catch (e) {
                      toast(context, e.toString());
                      next(); // This is for debug purpose. TODO: delete this
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

// Widget for AuthStep 02: Ask user to click verification link
class EmailSignUpVerification extends StatelessWidget {
  const EmailSignUpVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      constraints: BoxConstraints(maxWidth: 600),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              "A verification Email has been sent to your address",
              textAlign: TextAlign.center,
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
                          toast(context, "We have resent another verification email to ");
                        }
                    )
                  ]
              ))
          ),
          Container(
            padding: EdgeInsets.only(top: 50),
              child: SizedBox(
                height: 50,
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.onPrimary),
                      onPressed: () {
                        // TODO: Check verification
                        toast(context, "TODO");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DevHome()));
                      },
                      child: Text("I have verified my Email")),
                ),
              )
          )
        ],
      ),
    );
  }
}


