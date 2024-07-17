import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import '../../models/filter.dart';

void showFilter(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: MatchFilter(),
      );
    }
  );
}

class MatchFilter extends StatefulWidget {
  const MatchFilter({super.key});

  @override
  State<MatchFilter> createState() => _MatchFilterState();
}

class _MatchFilterState extends State<MatchFilter> {
  HashSet<PracticeOption> practiceOptionsSelection = HashSet();
  HashSet<YiddishProficiency> yiddishProficiencySelection = HashSet();
  double distanceSelection = 1000;
  RangeValues ageRangeSelection = RangeValues(0, 100);


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,

      children: [
        // "Filters"
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Align(
            alignment: Alignment.center,
            child: Text("Filters", style: Theme.of(context).textTheme.displaySmall,),
          ),
        ),

        // Practice Option
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Practice Option",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.start,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // "Online"
                  Expanded(
                    child: CheckboxListTile(
                      value: practiceOptionsSelection.contains(PracticeOption.online),
                      onChanged: (bool? value) => setState(() {
                        if (value == true) {
                          practiceOptionsSelection.add(PracticeOption.online);
                        } else {
                          practiceOptionsSelection.remove(PracticeOption.online);
                        }
                        print( "onchange 1-1!");
                      }),
                      title: Text("Online"),
                    ),
                  ),
                  // "In-Person"
                  Expanded(
                    child: CheckboxListTile(
                      value: practiceOptionsSelection.contains(PracticeOption.inPerson),
                      onChanged: (bool? value) => setState(() {
                        if (value == true) {
                          practiceOptionsSelection.add(PracticeOption.inPerson);
                        } else {
                          practiceOptionsSelection.remove(PracticeOption.inPerson);
                        }
                        // print( "onchange 1-2!");
                      }),
                      title: Text("In-Person"),
                    ),
                  )
                ],
              )
            ],
          ),
        ),

        // Yiddish Proficiency
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Yiddish Proficiency",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.start,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // "Beginner"
                  Expanded(
                    child: CheckboxListTile(

                      value: yiddishProficiencySelection.contains(YiddishProficiency.beginner),
                      onChanged: (bool? value) => setState(() {
                        if (value == true) {
                          yiddishProficiencySelection.add(YiddishProficiency.beginner);
                        } else {
                          yiddishProficiencySelection.remove(YiddishProficiency.beginner);
                        }
                        // print( "onchange 2-1!");
                      }),
                      title: Text("Beginner"),
                    ),
                  ),
                  // "Intermediate"
                  Expanded(
                    child: CheckboxListTile(
                      value: yiddishProficiencySelection.contains(YiddishProficiency.intermediate),
                      onChanged: (bool? value) => setState(() {
                        if (value == true) {
                          yiddishProficiencySelection.add(YiddishProficiency.intermediate);
                        } else {
                          yiddishProficiencySelection.remove(YiddishProficiency.intermediate);
                        }
                        // print( "onchange 2-2!");
                      }),
                      title: Text("Intermediate"),
                    ),
                  ),
                  // "Proficient"
                  Expanded(
                    child: CheckboxListTile(

                      value: yiddishProficiencySelection.contains(YiddishProficiency.fluent),
                      onChanged: (bool? value) => setState(() {
                        if (value == true) {
                          yiddishProficiencySelection.add(YiddishProficiency.fluent);
                        } else {
                          yiddishProficiencySelection.remove(YiddishProficiency.fluent);
                        }
                        // print( "onchange 2-3!");
                      }),
                      title: Text("Fluent"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),

        // Distance
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Distance",
                    style: Theme.of(context).textTheme.titleLarge
                  ),
                  Text(
                    "${distanceSelection.round()} km",
                    style: Theme.of(context).textTheme.bodyLarge
                  ),
                ],
              ),
              Slider(
                min: 0,
                max: 1000,
                value: distanceSelection,
                label: "${distanceSelection.round()}",
                onChanged: (double value) => setState(() {
                  distanceSelection = value;
                }),
              )
            ],
          ),
        ),

        // Age
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "Age",
                      style: Theme.of(context).textTheme.titleLarge
                  ),
                  Text(
                      "${(ageRangeSelection.start).round()} ~ ${(ageRangeSelection.end).round()}",
                      style: Theme.of(context).textTheme.bodyLarge
                  ),
                ],
              ),
              RangeSlider(
                  min: 0,
                  max: 100,
                  divisions: 100,
                  values: ageRangeSelection,
                  labels: RangeLabels("${ageRangeSelection.start.round()}", "${ageRangeSelection.end.round()}"),
                  onChanged: (RangeValues value) => setState(() {
                    ageRangeSelection = value;
                  })
              )
            ],
          ),
        ),

        // "Reset" and "Apply"
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // "Reset"
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  size: 48,
                ),
                color: Colors.orange,
                onPressed: () => {
                  setState(() {
                    practiceOptionsSelection.clear();
                    yiddishProficiencySelection.clear();
                    distanceSelection = 1000.0;
                    ageRangeSelection = RangeValues(0.0, 100.0);
                  })
                },
              ),
              // "Apply"
              IconButton(
                icon: Icon(
                  Icons.check,
                  size: 48,
                ),
                color: Colors.green,
                onPressed: () => {
                  setState(() {
                    toast(context, "TODO: Update the provider");
                    Navigator.pop(context);
                  })
                },
              ),
            ],
          ),
        ),

      ],
    );
  }
}

