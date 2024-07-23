// lib/widgets/filter_widget.dart
import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  final List<String> ages;
  final List<String> genders;
  final void Function(String?)? onAgeSelected; // Update to nullable String
  final void Function(String?)? onGenderSelected; // Update to nullable String

  FilterWidget({
    required this.ages,
    required this.genders,
    this.onAgeSelected,
    this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          items: ages.map((age) => DropdownMenuItem(value: age, child: Text(age))).toList(),
          onChanged: onAgeSelected,
          hint: Text('Select Age'),
        ),
        DropdownButton<String>(
          items: genders.map((gender) => DropdownMenuItem(value: gender, child: Text(gender))).toList(),
          onChanged: onGenderSelected,
          hint: Text('Select Gender'),
        ),
      ],
    );
  }
}
