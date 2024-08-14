import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import '../ui/auth/dev_signin_signup/dev_home.dart';
import '../services/firebaseAuthentication.dart';

class OneStep {
  final String title;
  final Widget Function(void Function() prev, void Function() next) builder;
  ///   @param title: name of the step
  ///   @param builder: lambda function like (prev, next) => MyWidget(...). How to build the child Widget of PageView.
  ///
  ///   Example: OneStep(title: "Verify login", builder: (prev, next) => _Step1(onButtonClicked: next)),
  ///
  ///   *Note* You can pass none, either or both of prev and next to a Step.
  OneStep({required this.title, required this.builder});
}

class MultiSteps extends StatefulWidget {
  final List<OneStep> steps;
  final String title;
  final bool hasProgress;
  final bool hasButton;
  final bool enableBack;
  final bool enableSwipe;
  final void Function()? onComplete;

  /// @param steps: An array of OneStep()
  ///
  /// @param title: Title in Appbar
  ///
  /// @param hasProgress: Whether enables the progress bar
  ///
  /// @param hasButton: Whether enables the 'next' button. (If not, please make use of the 'prev' and 'next' passed from the builder)
  ///
  /// Example: Widget build(BuildContext context) {
  ///     return MultiSteps(
  ///       steps: [
  ///         OneStep(title: "Enter your phone number (+1)", builder: (prev, next) => _Step1(onButtonClicked: next)),
  ///         OneStep(title: "Are you a real human?", builder: (prev, next) => _Step1(onSwipe: prev)),
  ///         OneStep(title: "Verify login", builder: (prev, next) => _Step1(onClick: next, onDoubleClick: prev)),
  ///       ],
  ///     );
  ///
  /// *Note*: MultiSteps doesn't support custom state. Consider using a provider or a InheritedWidget.
  const MultiSteps({super.key, required this.steps, required this.title, this.hasProgress = false, this.hasButton = false, this.onComplete, this.enableBack = true, this.enableSwipe = true});

  @override
  State<MultiSteps> createState() => _MultiStepsState();
}

class _MultiStepsState extends State<MultiSteps> with TickerProviderStateMixin {
  int _page = 0; // 0 <= _page <= _size. After the user click proceeds in the last step, _page becomes _size
  late int _size;
  PageController _pageController = PageController();
  late AnimationController _animationController;
  Animation<Color?>? _colorAnimation;
  Animation<double>? _progressAnimation;
  Duration _switchDuration = Duration(milliseconds: 300); // switching between steps
  Duration _animationDuration = Duration(seconds: 1);
  final Color? _startColor = Colors.red[200];
  final Color? _endColor = Colors.green[200];

  @override
  void initState() {
    super.initState();
    _size = widget.steps.length;
    _animationController = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
      // setState(() {});
    });
  }

  void _next() {
    setState((){
      if (_page >= _size) {
        return;
      } else if (_page < _size - 1) {
        _pageController.animateToPage(_page + 1, duration: _switchDuration, curve: Curves.easeInOut);
      } else if (_page == _size - 1) {
        // When you click next in last step
        int oldIndex = _size - 1;
        int newIndex = _size;
        _page++;

        // Create & play new animations. Old: _page  New: _page + 1
        double oldProgress = oldIndex / _size;
        double newProgress = newIndex / _size;
        Color? oldColor = Color.lerp(_startColor, _endColor, oldIndex / _size); // interpolation
        Color? newColor = Color.lerp(_startColor, _endColor, newIndex / _size); // interpolation
        _colorAnimation = ColorTween(begin: oldColor, end: newColor).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
        _progressAnimation = Tween<double>(begin: oldProgress, end: newProgress).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
        _animationController.forward(from: 0.0);

        Future.delayed(_animationDuration, () {
          widget.onComplete?.call();
        });
      }
    });
  }

  void _prev() {
    setState(() {
      if (_page <= 0) {
        return;
      } else if (_page == _size) {
        // When you click prev in last step
        int oldIndex = _size;
        int newIndex = _size - 1;
        _page --;

        // Create & play new animations. Old: _page  New: _page + 1
        double oldProgress = oldIndex / _size;
        double newProgress = newIndex / _size;
        Color? oldColor = Color.lerp(_startColor, _endColor, oldIndex / _size); // interpolation
        Color? newColor = Color.lerp(_startColor, _endColor, newIndex / _size); // interpolation
        _colorAnimation = ColorTween(begin: oldColor, end: newColor).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
        _progressAnimation = Tween<double>(begin: oldProgress, end: newProgress).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
        _animationController.forward(from: 0.0);
      } else if (_page > 0 && _page < _size) {
        _pageController.animateToPage(_page - 1, duration: _switchDuration, curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    // print("MultiSteps disposed...");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("MultiSteps built...");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    physics: widget.enableSwipe ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      print("onPageChanged");
                      setState(() {
                        int oldIndex = _page;
                        int newIndex = index;
                        // print ("$_page  $index");
                        _page = index;
                        // Create & play new animations. Old: _page  New: _page + 1
                        double oldProgress = oldIndex / _size;
                        double newProgress = newIndex/ _size;
                        Color? oldColor = Color.lerp(_startColor, _endColor, oldIndex / _size); // interpolation
                        Color? newColor = Color.lerp(_startColor, _endColor, newIndex / _size); // interpolation
                        _colorAnimation = ColorTween(begin: oldColor, end: newColor)
                            .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
                        _progressAnimation = Tween<double>(begin: oldProgress, end: newProgress)
                            .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
                        _animationController.forward(from: 0.0);
                      });
                    },
                    children: widget.steps.asMap().entries.map((stepEntry) => stepBuilder(context, stepEntry.value.title, stepEntry.value.builder, stepEntry.key)).toList(),
                  ),
                  if (widget.hasProgress) Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text("$_page/$_size Done", style: Theme.of(context).textTheme.titleLarge,),
                    ),
                  ),
                  if (widget.hasButton) Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.enableBack == true) Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 75,
                              height: 75,
                              child: FloatingActionButton(
                                heroTag: "prev",
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0), // set the desired border radius
                                ),
                                onPressed: _prev,
                                child: Icon(Icons.navigate_before),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 75,
                              height: 75,
                              child: FloatingActionButton(
                                heroTag: "next",
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0), // set the desired border radius
                                ),
                                onPressed: _next, // Change this for extensibility
                                child: Icon(Icons.navigate_next),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (widget.hasProgress) Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 30),
                // color: Colors.amberAccent,
                child: FractionallySizedBox(
                  alignment: Alignment.center,
                  widthFactor: 0.9,
                    child: Container(
                      alignment: Alignment.center,
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            value: _progressAnimation?.value ?? 0,
                            valueColor: _colorAnimation ?? null,
                            backgroundColor: Colors.grey[300],
                            minHeight: 30,
                            borderRadius: BorderRadius.all(Radius.circular(15))
                          );
                        },
                      )
                    )
                ),
              ),
            )
          ],
      ),
    );
  }

  /// @param builder: a lambda function that takes a callback function and create the ActionWidget accordingly.
  ///   *Extensibility* In MultiSteps, the callback function will always be _next(), which is navigating to next step.
  ///   But the action that those ActionWidgets will take can be changed.
  ///
  /// Example: stepBuilder(context, "Step No.1", (prev, next) => EmailSignInPage(onVerifyButtonClicked: next))
  Widget stepBuilder(BuildContext context, String title, Widget Function(void Function() prev, void Function() next) builder, int pageIndex) {
    // print("stepBuilder of $title ...");

    return Container(
      key: PageStorageKey<String>('page_$pageIndex'),
      padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // _Step title
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
            ),
            // _Step widget content
            Container(
                child: builder(_prev, _next) // *Extensibility* Replace the _next, if you want each ActionWidget to do something different.
            )
          ],
        ),
    );
  }
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

