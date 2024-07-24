import 'package:flutter/material.dart';
import '../../widgets/filter_widget.dart';

class FilterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilterWidget(
      genders: ['Male', 'Female', 'Non-binary'],
      onGenderSelected: (String? gender) {
        // Handle gender selection, check if gender is not null
        if (gender != null) {
          // Perform actions with the selected gender
        }
      },
      onAgeRangeSelected: (RangeValues ageRange) {
        // Handle age range selection
      },
      onDistanceSelected: (double distance) {
        // Handle distance selection
      },
    );
  }
}
