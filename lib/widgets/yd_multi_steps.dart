import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import '../screens/dev_signin_signup/dev_home.dart';
import '../services/auth.dart';

/// Each step needs the following info:
///   @param title: name of the step
///   @param builder: lambda function like (callback) => MyWidget(callback). How to build the ActionWidget using a callback function.
///   *Note*: By default the callback is always 'MultiStep._next'
class OneStep {
  final String title;
  final ActionWidget Function(void Function() callback) builder;
  OneStep({required this.title, required this.builder});
}

/// Example: Widget build(BuildContext context) {
///     return MultiSteps(
///       steps: [
///         OneStep(title: "Enter your phone number (+1)", builder: (callback) => _Step1(action: callback)),
///         OneStep(title: "Are you a real human?", builder: (callback) => _Step1(action: callback)),
///         OneStep(title: "Verify login", builder: (callback) => _Step1(action: callback)),
///       ],
///     );
///
/// Note: MultiSteps doesn't support custom state. Consider using a provider or a InheritedWidget.
class MultiSteps extends StatefulWidget {
  final List<OneStep> steps;
  const MultiSteps({super.key, required this.steps});

  @override
  State<MultiSteps> createState() => _MultiStepsState();
}

class _MultiStepsState extends State<MultiSteps> {
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
    print("MultiSteps disposed...");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("MultiSteps built...");
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _page = index;
          });
        },
        children: widget.steps.asMap().entries.map((stepEntry) => stepBuilder(context, stepEntry.value.title, stepEntry.value.builder, stepEntry.key)).toList(),
      )
    );
  }

  /// @param builder: a lambda function that takes a callback function and create the ActionWidget accordingly.
  ///   *Extensibility* In MultiSteps, the callback function will always be _next(), which is navigating to next step.
  ///   But the action that those ActionWidgets will take can be changed.
  ///
  /// Example: stepBuilder(context, "Step No.1", (callback) => EmailSignInPage(callback))
  Widget stepBuilder(BuildContext context, String title, ActionWidget Function(void Function() callback) builder, int pageIndex) {
    print("stepBuilder of $title ...");
    return Container(
      key: PageStorageKey<String>('page_$pageIndex'),
      padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
            ),
            Container(
                child: builder(_next) // *Extensibility* Replace the _next, if you want each ActionWidget to do something different.
            )
          ],
        )
    );
  }
}

abstract class ActionWidget extends StatelessWidget {
  final void Function() action;

  const ActionWidget({super.key, required this.action});
}


// class Parent extends StatelessWidget {
//   final int a = 19;
//   const Parent({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Center(child: Sub(num: a)),
//     );
//   }
// }
//
// class Sub extends StatelessWidget {
//   Sub({super.key, required this.num});
//   int num;
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(num.toString());
//   }
// }
//
//

