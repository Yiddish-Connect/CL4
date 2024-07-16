import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;
  final Color borderColor;
  final Color backgroundColor;
  final double height;
  final double width;
  final double opacity;

  const Label({
    super.key,
    required this.text,
    required this.borderColor,
    required this.backgroundColor,
    this.height = 30,
    this.width = 100,
    this.opacity = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
