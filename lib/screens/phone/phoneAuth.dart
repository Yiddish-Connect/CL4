import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yiddishconnect/widgets/yd_multi_steps.dart';
import 'dart:io';
import '../../services/auth.dart';
import '../../utils/helpers.dart';
import '../dev_signin_signup/dev_home.dart';

class PhoneAuthScreen extends StatelessWidget {
  const PhoneAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PhoneProvider(),
      child: MultiSteps(
        steps: [
          OneStep(title: "Enter your phone number (+1)", builder: (callback) => _Step1(action: callback)),
          OneStep(title: "Enter 4-digits code", builder: (callback) => _Step2(action: callback)),
        ],
      ),
    );
  }
}

class PhoneProvider extends ChangeNotifier {
  String _phoneNumber = "";
  PhoneAuthTokenCrossPlatform? _token;

  String get phoneNumber => _phoneNumber;
  PhoneAuthTokenCrossPlatform? get token => _token;

  set phoneNumber (String newPhoneNumber) {
    _phoneNumber = newPhoneNumber;
    notifyListeners();
  }
  set token (PhoneAuthTokenCrossPlatform? newToken) {
    _token = newToken;
    notifyListeners();
  }
}

// Step1: Enter the phone number
class _Step1 extends ActionWidget {
  final TextEditingController _phoneNumberController = TextEditingController();
  final AuthService _auth = AuthService();
  
  _Step1({super.key, required super.action});

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
            child: TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: '(123) 456-7890',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              onChanged: (value) => Provider.of<PhoneProvider>(context, listen: false).phoneNumber = "+1 $value", // no need to rebuild a TextField
            )
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
                        try {
                          String phoneNumber = context.read<PhoneProvider>().phoneNumber;
                          // Might take some time in Android. Because Firebase will first try to do auto-complete first before codeAutoRetrievalTimeout() happens.
                          toast(context, "SMS code sent to $phoneNumber");
                          PhoneAuthTokenCrossPlatform token = await _auth.sendCodeToPhoneNumber(phoneNumber);
                          // if (Platform.isAndroid && token is PhoneAuthTokenNative && token.phoneAuthCredential != null) {
                          //   toast(context, "Successfully auto-fill SMS code");
                          //   await _auth.auth.signInWithCredential(token.phoneAuthCredential!);
                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => DevHome()));
                          // }
                          // // else go through the normal 'enter sms code' process
                          Provider.of<PhoneProvider>(context, listen: false).token = token;

                          action();
                        } catch (e) {
                          toast(context, e.toString());
                        }
                      },
                      child: Text("Send SMS code")),
                ),
              )
          )
        ],
      ),
    );
  }
}

// _Step2: Enter your SMS code
class _Step2 extends ActionWidget {
  final TextEditingController _codeController = TextEditingController();
  final AuthService _auth = AuthService();

  _Step2({super.key, required super.action});

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
            child: Consumer<PhoneProvider>(
              builder: (context, phoneNumberProvider, child) {
                return Text(
                  "Enter OTP code we sent to ${phoneNumberProvider.phoneNumber}. This code will expire in 2 minutes",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                );
              }
            ),
          ),
          Container(
              padding: EdgeInsets.all(5),
              child: TextField(
                controller: _codeController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: '4-digits code',
                  hintText: '0000',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              )
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
                        try {
                          String smsCode = _codeController.text;
                          if (context.read<PhoneProvider>().token == null) {
                            throw Exception("token is still null on _Step2");
                          }
                          PhoneAuthTokenCrossPlatform token = context.read<PhoneProvider>().token!;

                          User? user = await _auth.signInWithSMSCode(token, smsCode);
                          if (user != null) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DevHome()));
                          } else {
                            toast(context, "Something went wrong (null)");
                          }
                        } catch (e) {
                          toast(context, e.toString());
                        }
                      },
                      child: Text("Verify")),
                ),
              )
          )
        ],
      ),
    );
  }
}

class _Step3 extends ActionWidget {
  const _Step3({super.key, required super.action});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


