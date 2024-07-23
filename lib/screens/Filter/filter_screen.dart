// lib/screens/filter_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/filter_widget.dart';

class FilterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter'),
      ),
      body: FilterWidget(
        ages: ['18-25', '26-35', '36-45', '46+'],
        genders: ['Male', 'Female', 'Other'],
        onAgeSelected: (String? age) {
          // Handle age selection, check if age is not null
          if (age != null) {
            // Perform actions with the selected age
          }
        },
        onGenderSelected: (String? gender) {
          // Handle gender selection, check if gender is not null
          if (gender != null) {
            // Perform actions with the selected gender
          }
        },
      ),
    );
  }
}
