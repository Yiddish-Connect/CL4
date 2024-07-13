import 'dart:math';
import 'package:flutter/material.dart';

/// This class build an animated curve. The dot in the curve are controlled by an animation.
/// Here I used the Trisectrix of Maclaurin to achieve a gamma-like shape.
/// For extensibility, modify the mathematics equations. Please search for "modify here"
class AnimatedCurve extends StatefulWidget {
  AnimatedCurve({super.key});

  @override
  State<AnimatedCurve> createState() => _AnimatedCurveState();
}

class _AnimatedCurveState extends State<AnimatedCurve> with TickerProviderStateMixin {
  final Duration _animationDuration = Duration(seconds: 3);
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  Path path1 = Path();
  Path path2 = Path();
  int path1Count = 0;
  int path2Count = 0;
  final int numPoints = 1000; // How many data points in each curve
  double lastProgress = 0.0;
  double range = 0.8; // Percentage of the Trisectrix of Maclaurin to display
  double a = 0.7; // math parameter
  double xLim = 3; // math x range. Change this to make shape larger in the canvas.
  double yLim = 3; // math y range. Chane this to make shape larger in the canvas.
  double canvasWidth = 300; // canvas width of CustomPaint
  double canvasHeight = 300; // canvas height of CustomPaint

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: _animationDuration,
    )..addListener(_updatePath);
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward(from: 0);
    // _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// I store the path1 and path2 in my AnimatedCurve widget instead of the CustomPaint (where path is commonly stored).
  /// This is to efficiently reuse the previous path.
  /// i.e. I add new point to the existing path1, path2, instead of calculating the path from scratch every animation frame.
  void _updatePath() {
    int startPoint = (numPoints * lastProgress).toInt();
    int endPoint = (numPoints * _progressAnimation.value).toInt();

    for (int i = startPoint; i < endPoint; i++) {
      double deltaTheta = 0.5 * pi * range;
      double dTheta = deltaTheta / numPoints;
      double theta1 = i * dTheta;
      double theta2 = pi - i * dTheta;

      double r1 = (sin(2 * theta1) != 0) ? 2 * a * sin(3 * theta1) / sin(2 * theta1) : 2 * a * 3 / 2;
      double r2 = (sin(2 * theta2) != 0) ? 2 * a * sin(3 * theta2) / sin(2 * theta2) : 2 * a * 3 / 2;

      double x1 = r1 * cos(theta1);
      double y1 = r1 * sin(theta1);
      double x2 = r2 * cos(theta2);
      double y2 = r2 * sin(theta2);

      double plotMidX = canvasWidth / 2;
      double plotMidY = canvasHeight / 2;

      double plotX1 = plotMidX + x1 / xLim * canvasWidth; // convert the (x, y) to position on canvas
      double plotY1 = plotMidY - y1 / yLim * canvasHeight; // convert the (x, y) to position on canvas
      double plotX2 = plotMidX + x2 / xLim * canvasWidth; // convert the (x, y) to position on canvas
      double plotY2 = plotMidY - y2 / yLim * canvasHeight; // convert the (x, y) to position on canvas

      if (i == 0 && startPoint == 0) {
        path1.moveTo(plotX1, plotY1);
        path2.moveTo(plotX2, plotY2);
      } else {
        path1.lineTo(plotX1, plotY1);
        path2.lineTo(plotX2, plotY2);
      }
      path1Count ++;
      path2Count ++;
    }
    lastProgress = _progressAnimation.value; // update lastProgress
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 300,
        maxWidth: 500,
        minHeight: 300,
        maxHeight: 300
      ),
      color: Colors.grey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return Column(
                children: [
                  // Text("${_progressAnimation.value.toString()}  ${(20 * _progressAnimation.value).floor()}"),
                  CustomPaint(
                    size: Size(canvasWidth, canvasHeight),
                    painter: CurvePainter(
                      color1: Theme.of(context).colorScheme.surface,
                      color2: Theme.of(context).colorScheme.primary,
                      path1: path1,
                      path2: path2,
                      path1Count: path1Count,
                      path2Count: path2Count,
                      strokeWidth: 5 + 10 * sin(_progressAnimation.value * pi) // Dynamic stroke width
                    ),
                  ),
                ],
              );
            }
          );
        },
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final Color color1; // start gradient color of the curve
  final Color color2; // end gradient color of the curve
  final Path path1; // Reference. The object is actually stored in AnimatedCurve. (To persist between frames)
  final Path path2; // Reference. The object is actually stored in AnimatedCurve. (To persist between frames)
  final int path1Count;
  final int path2Count;
  final double strokeWidth;

  CurvePainter({required this.color1, required this.color2, required this.path1, required this.path2, required this.path1Count, required this.path2Count, this.strokeWidth = 10});

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      colors: [color1, color2],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth// Dynamic stroke width
        ..isAntiAlias = true;
    // Apply rotation
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-pi * 3.0 / 7.0);
    canvas.translate(-size.width / 2, -size.height / 2);

    // parameter 'a' will affect the relative position of the curve in [-xLim, xLim].
    // It's the intrinsic math property of the curve r = 2*a*sin(3theta)/sin(2theta)
    // I can't find a good math function to translate it according to "a". So I do it manually here every time I change "a".
    canvas.translate(-size.width / 5, 0);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Here's another optimization. I keep track of the number of points added to the path.
    // The canvas will only repaint when the number of points is different from the old delegate
    return oldDelegate is CurvePainter &&
        (oldDelegate.path1Count != path1Count || oldDelegate.path2Count != path2Count);
  }
}