import 'dart:math';
import 'package:flutter/material.dart';

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
  final int numPoints = 1000;
  double lastProgress = 0.0;
  double range = 0.8;
  double a = 0.7;
  double xLim = 3;
  double yLim = 3;
  double canvasWidth = 300;
  double canvasHeight = 300;
  double precision = 1e-9;
  double offset = 0.2;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(_updatePath);
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double roundToPrecision(double value) {
    return (value / precision).round() * precision;
  }

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

      double plotX1 = (plotMidX + x1 / xLim * canvasWidth);
      double plotY1 = (plotMidY - y1 / yLim * canvasHeight);
      double plotX2 = (plotMidX + x2 / xLim * canvasWidth);
      double plotY2 = (plotMidY - y2 / yLim * canvasHeight);

      if (i == 0 && startPoint == 0) {
        path1.moveTo(plotX1 + offset, plotY1 + offset);
        path2.moveTo(plotX2 - offset, plotY2 - offset);
      } else {
        path1.lineTo(plotX1, plotY1);
        path2.lineTo(plotX2, plotY2);
      }
      path1Count++;
      path2Count++;
    }
    lastProgress = _progressAnimation.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 300,
        maxWidth: 500,
        minHeight: 300,
        maxHeight: 300,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CustomPaint(
                      size: Size(canvasWidth, canvasHeight),
                      painter: CurvePainter(
                        color1: Theme.of(context).colorScheme.surface,
                        color2: Theme.of(context).colorScheme.primary,
                        path1: path1,
                        path2: path2,
                        path1Count: path1Count,
                        path2Count: path2Count,
                        strokeWidth: 5 + 10 * sin(_progressAnimation.value * pi),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final Path path1;
  final Path path2;
  final int path1Count;
  final int path2Count;
  final double strokeWidth;

  CurvePainter({
    required this.color1,
    required this.color2,
    required this.path1,
    required this.path2,
    required this.path1Count,
    required this.path2Count,
    this.strokeWidth = 10,
  });

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
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-pi * 3.0 / 7.0);
    canvas.translate(-size.width / 2, -size.height / 2);
    canvas.translate(-size.width / 5, 0);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is CurvePainter &&
        (oldDelegate.path1Count != path1Count || oldDelegate.path2Count != path2Count);
  }
}