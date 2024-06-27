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
import '../../utils/formatters.dart';
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
          OneStep(title: "Step 1: Enter your phone number (+1)", builder: (callback) => _Step1(action: callback)),
          OneStep(title: "Step 2: Enter 6-digits code", builder: (callback) => _Step2(action: callback)),
          // OneStep(title: "testing", builder: (callback) => _Step3(action: callback)),
        ],
      ),
    );
  }
}

class PhoneProvider extends ChangeNotifier {
  String _phoneNumber = "";
  ConfirmationResult? _confirmationResult; // Web only.
  PhoneAuthCredential? _phoneAuthCredential; // Android Auto-Resolution. phoneAuthCredential != null <=> Android auto complete successful.
  String? _verificationId; // Native only.

  String get phoneNumber => _phoneNumber;

  ConfirmationResult? get confirmationResult => _confirmationResult;

  PhoneAuthCredential? get phoneAuthCredential => _phoneAuthCredential;

  String? get verificationId => _verificationId;

  set phoneNumber(String newPhoneNumber) {
    _phoneNumber = newPhoneNumber;
    notifyListeners();
  }

  set confirmationResult(ConfirmationResult? newConfirmationResult) {
    _confirmationResult = newConfirmationResult;
    notifyListeners();
  }

  set phoneAuthCredential(PhoneAuthCredential? newPhoneAuthCredential) {
    _phoneAuthCredential = newPhoneAuthCredential;
    notifyListeners();
  }

  set verificationId(String? newVerificationId) {
    _verificationId = newVerificationId;
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
    print("_Step1 built...");
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
                  inputFormatters: [PhoneNumberFormatter()],
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '(123) 456-7890',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  onChanged: (value) {
                    final rawNumber = value.replaceAll(RegExp(r'\D'), ''); // Remove formatting for storing raw number
                    Provider
                        .of<PhoneProvider>(context, listen: false)
                        .phoneNumber = "+1 $rawNumber"; // no need to rebuild a TextField
                  }
              )
          ),
          Container(
              padding: EdgeInsets.only(top: 40),
              child: SizedBox(
                height: 50,
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Theme
                          .of(context)
                          .colorScheme
                          .primary, foregroundColor: Theme
                          .of(context)
                          .colorScheme
                          .onPrimary),
                      onPressed: () async {
                        print("onPressed() called...");
                        try {
                          String phoneNumber = context
                              .read<PhoneProvider>()
                              .phoneNumber;
                          toast(context, "SMS code sent to $phoneNumber");
                          // Web only. Will be triggered when code successfully sent.
                          void onConfirmationResult(ConfirmationResult confirmationResult) {
                            print("onConfirmationResult() called...");
                            Provider
                                .of<PhoneProvider>(context, listen: false)
                                .confirmationResult = confirmationResult;
                            action();
                          }
                          // Native only. Will be triggered when code successfully sent.
                          void onCodeSent(String verificationId) {
                            print("onCodeSent() called...");
                            if (!context.mounted) {
                              throw Exception("onCodeSent(): context.mounted is false!!");
                              return;
                            }
                            Provider
                                .of<PhoneProvider>(context, listen: false)
                                .verificationId = verificationId;
                            action(); // go to next page
                          }
                          // Android Native only. Will be triggered when code successfully auto resolved
                          void onAutoResolution(PhoneAuthCredential credential) {
                            print("onAutoResolution() called...");
                            if (!context.mounted) {
                              throw Exception("onAutoResolution(): context.mounted is false!!");
                              return;
                            }
                            Provider
                                .of<PhoneProvider>(context, listen: false)
                                .phoneAuthCredential = credential;
                          }
                          await _auth.sendCodeToPhoneNumber(phoneNumber, onConfirmationResult, onCodeSent, onAutoResolution);
                        } catch (e) {
                          toast(context, e.toString());
                        }
                      },
                      child: Text("Send SMS code")
                  ),
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

  final AuthService _auth = AuthService();

  _Step2({super.key, required super.action});

  @override
  Widget build(BuildContext context) {
    print("_Step2 built...");
    return Consumer<PhoneProvider>(
        builder: (context, phoneNumberProvider, child) {
          final TextEditingController codeController = TextEditingController(text: phoneNumberProvider.phoneAuthCredential != null ? phoneNumberProvider.phoneAuthCredential?.smsCode ?? "" : "");
          return Container(
            padding: EdgeInsets.all(30),
            constraints: BoxConstraints(maxWidth: 600),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Enter the OTP code we sent to (${phoneNumberProvider.phoneNumber.substring(3, 6)})-${phoneNumberProvider.phoneNumber.substring(6, 9)}-${phoneNumberProvider.phoneNumber.substring(9, 13)}. The code expires in 5 minutes",
                      textAlign: TextAlign.center,
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,
                    )
                ),
                Container(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      controller: codeController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: '6-digits code',
                        hintText: "123456",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    )
                ),
                Container(
                    padding: EdgeInsets.only(top: 40),
                    child: SizedBox(
                      height: 50,
                      child: FractionallySizedBox(
                        widthFactor: 0.6,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Theme
                                .of(context)
                                .colorScheme
                                .primary, foregroundColor: Theme
                                .of(context)
                                .colorScheme
                                .onPrimary),
                            onPressed: () async {
                              try {
                                String smsCode = codeController.text;
                                User? user = await _auth.signInWithSMSCode(
                                    smsCode: smsCode,
                                    verificationId: context
                                        .read<PhoneProvider>()
                                        .verificationId,
                                    phoneAuthCredential: context
                                        .read<PhoneProvider>()
                                        .phoneAuthCredential,
                                    confirmationResult: context
                                        .read<PhoneProvider>()
                                        .confirmationResult
                                );
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
    );
  }
}

class _Step3 extends ActionWidget {
  const _Step3({super.key, required super.action});

  @override
  Widget build(BuildContext context) {
  print("_Step3 built");
  return const Placeholder();
  }
}




