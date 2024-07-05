import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import 'package:yiddishconnect/widgets/yd_multi_steps.dart';

class PreferenceScreen extends StatelessWidget {
  const PreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSteps(
      title: "Preference",
      steps: [
        OneStep(title: "What's your name?", builder: (callback) => _Step1(action: callback)),
        OneStep(title: "Location", builder: (callback) => _Step2(action: callback)),
        OneStep(title: "Select up to 5 interests", builder: (callback) => _Step3(action: callback)),
        OneStep(title: "Upload your photos", builder: (callback) => _Step4(action: () {
          // TODO: Show a 'you are Verified' modal instead
          toast(context, "You are verified");
          context.go("/home");
        })),
      ],
    );
  }
}

// What's your name
class _Step1  extends ActionWidget {
  _Step1 ({super.key, required super.action});
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(30),
        constraints: BoxConstraints(
          maxHeight: 300,
          maxWidth: 300
        ),
        color: Colors.red,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: TextField(controller: nameController,)
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: action,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.navigate_next,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 30,
                ),
              )
            )
          ],
        )
    );
  }
}

// Location
class _Step2 extends ActionWidget {
  const _Step2({super.key, required super.action});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// Select up to 5 interests
class _Step3 extends ActionWidget {
  const _Step3({super.key, required super.action});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// Upload your photos
class _Step4 extends ActionWidget {
  const _Step4({super.key, required super.action});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
