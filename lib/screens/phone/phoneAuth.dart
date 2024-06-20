import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yiddishconnect/widgets/yd_multi_steps.dart';

import '../../utils/helpers.dart';

class PhoneAuth extends StatelessWidget {
  const PhoneAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSteps(
      steps: [
        StepInfo(title: "Enter your phone number (+1)", builder: (callback) => _Step1(action: callback)),
        StepInfo(title: "Are you a real human?", builder: (callback) => _Step1(action: callback)),
        StepInfo(title: "Verify login", builder: (callback) => _Step1(action: callback)),
      ],
    );
  }
}

// Step1: Enter the phone number
class _Step1 extends ActionWidget {
  final TextEditingController _phoneNumberController = TextEditingController();

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
                      onPressed: () {
                        toast(context, "TODO");
                      },
                      child: Text("Send")),
                ),
              )
          )
        ],
      ),
    );
  }
}

// _Step2: reCAPTCHA
class _Step2 extends ActionWidget {
  const _Step2({super.key, required super.action});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _Step3 extends ActionWidget {
  const _Step3({super.key, required super.action});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


