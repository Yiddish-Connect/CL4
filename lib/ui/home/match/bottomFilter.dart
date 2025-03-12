import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yiddishconnect/ui/home/match/matchPageProvider.dart';
import '../../../models/filter.dart';

// Shows the Filter Bottom Sheet
void showFilter(BuildContext context) {
  MatchPageProvider matchPageProvider = Provider.of<MatchPageProvider>(context, listen: false);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: MatchFilter(dataProvider: matchPageProvider),
      );
    },
  );
}

// Main Filter Widget
class MatchFilter extends StatefulWidget {
  final MatchPageProvider dataProvider;

  const MatchFilter({super.key, required this.dataProvider});

  @override
  State<MatchFilter> createState() => _MatchFilterState();
}

class _MatchFilterState extends State<MatchFilter> {
  PracticeOption? selectedPracticeOption;
  YiddishProficiency? selectedProficiency;
  double distanceSelection = 1000;
  RangeValues ageRangeSelection = const RangeValues(0, 100);

  @override
  void initState() {
    super.initState();

    distanceSelection = widget.dataProvider.maxDistance.toDouble();
    ageRangeSelection = RangeValues(widget.dataProvider.minAge.toDouble(), widget.dataProvider.maxAge.toDouble());

    // Load Practice Option
    if (widget.dataProvider.practiceOptionsSelection.isNotEmpty) {
      try {
        selectedPracticeOption = PracticeOption.values.firstWhere(
              (e) => e.toString().split('.').last == widget.dataProvider.practiceOptionsSelection.first,
          orElse: () => PracticeOption.online,
        );
      } catch (e) {
        print("Invalid PracticeOption: ${widget.dataProvider.practiceOptionsSelection.first}");
      }
    }

    // Load Yiddish Proficiency
    if (widget.dataProvider.yiddishProficiencySelection.isNotEmpty) {
      try {
        selectedProficiency = YiddishProficiency.values.firstWhere(
              (e) => e.toString().split('.').last == widget.dataProvider.yiddishProficiencySelection,
          orElse: () => YiddishProficiency.beginner,
        );
      } catch (e) {
        print("Invalid YiddishProficiency: ${widget.dataProvider.yiddishProficiencySelection}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Align(
            alignment: Alignment.center,
            child: Text("Filters", style: Theme.of(context).textTheme.headlineMedium),
          ),
        ),
        _buildPracticeOptionSelection(),
        _buildProficiencySelection(),
        _buildSlider(title: "Distance", value: distanceSelection, min: 0, max: 1000),
        _buildAgeSlider(),
        _buildActionButtons(),
      ],
    );
  }

  // ✅ Fixed: Practice Option Selection (Single Choice)
  Widget _buildPracticeOptionSelection() {
    List<String> options = ["Remote", "In-Person", "Hybrid"];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Practice Option", style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: 10,
            children: options.map((option) {
              bool isSelected = widget.dataProvider.practiceOptionsSelection.contains(option);

              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
                selectedColor: Colors.green,
                onSelected: (selected) {
                  setState(() {
                    widget.dataProvider.updatePracticeOptions([option]);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ✅ Fixed: Yiddish Proficiency Selection (Single Choice)
  Widget _buildProficiencySelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Yiddish Proficiency", style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: 10,
            children: YiddishProficiency.values.map((proficiency) {
              bool isSelected = selectedProficiency == proficiency;
              return ChoiceChip(
                label: Text(proficiency.toString().split('.').last),
                selected: isSelected,
                selectedColor: Colors.green,
                onSelected: (selected) {
                  setState(() {
                    selectedProficiency = proficiency;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Distance Slider
  Widget _buildSlider({required String title, required double value, required double min, required double max}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text("${value.round()} km", style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          Slider(
            min: min,
            max: max,
            value: value,
            label: "${value.round()}",
            onChanged: (val) {
              setState(() {
                distanceSelection = val;
              });
            },
          ),
        ],
      ),
    );
  }

  // Age Range Slider
  Widget _buildAgeSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Age", style: Theme.of(context).textTheme.titleMedium),
              Text("${ageRangeSelection.start.round()} - ${ageRangeSelection.end.round()}",
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          RangeSlider(
            min: 0,
            max: 100,
            values: ageRangeSelection,
            labels: RangeLabels("${ageRangeSelection.start.round()}", "${ageRangeSelection.end.round()}"),
            onChanged: (RangeValues val) {
              setState(() {
                ageRangeSelection = val;
              });
            },
          ),
        ],
      ),
    );
  }

  // ✅ Fixed: Apply & Reset Buttons
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 48),
            color: Colors.orange,
            onPressed: () {
              setState(() {
                selectedPracticeOption = null;
                selectedProficiency = null;
                distanceSelection = 1000.0;
                ageRangeSelection = const RangeValues(0.0, 100.0);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.check, size: 48),
            color: Colors.green,
            onPressed: () {
              widget.dataProvider.setYiddishProficiency(selectedProficiency!.toString().split('.').last);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

