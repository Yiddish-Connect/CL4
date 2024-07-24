import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  final List<String> genders;
  final Function(String?) onGenderSelected;
  final Function(RangeValues) onAgeRangeSelected;
  final Function(double) onDistanceSelected;

  FilterWidget({
    required this.genders,
    required this.onGenderSelected,
    required this.onAgeRangeSelected,
    required this.onDistanceSelected,
  });

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String? selectedGender;
  RangeValues selectedAgeRange = RangeValues(18, 45);
  double selectedDistance = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Row(
            children: widget.genders.map((gender) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = gender;
                  });
                  widget.onGenderSelected(gender);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedGender == gender ? Colors.blue : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(gender),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
          Text(
            'Age Range',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          RangeSlider(
            values: selectedAgeRange,
            min: 18,
            max: 65,
            divisions: 47,
            labels: RangeLabels(
              '${selectedAgeRange.start.round()}',
              '${selectedAgeRange.end.round()}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                selectedAgeRange = values;
              });
              widget.onAgeRangeSelected(values);
            },
          ),
          SizedBox(height: 16.0),
          Text(
            'Distance (km)',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Slider(
            value: selectedDistance,
            min: 0,
            max: 100,
            divisions: 100,
            label: '${selectedDistance.toInt()} km',
            onChanged: (double value) {
              setState(() {
                selectedDistance = value;
              });
              widget.onDistanceSelected(value);
            },
          ),
        ],
      ),
    );
  }
}
