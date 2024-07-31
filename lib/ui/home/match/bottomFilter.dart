import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiddishconnect/ui/home/match/matchPageProvider.dart';
import '../../../models/filter.dart';

/// This function should be called in the match page.
/// It shows the bottom filter allowing users to select the filters, such as age and distance
/// *Note: The ModalBottomSheet is created in the root of the ENTIRE widget tree of the App, meaning it's not a child of the match page.
void showFilter(BuildContext context) {
  // assert: context contains the matchPageProvider
  MatchPageProvider matchPageProvider = Provider.of<MatchPageProvider>(context, listen: false);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: MatchFilter(dataProvider: matchPageProvider),
      );
    }
  );
}

class MatchFilter extends StatefulWidget {
  final MatchPageProvider dataProvider;

  MatchFilter({super.key, required this.dataProvider});

  @override
  State<MatchFilter> createState() => _MatchFilterState();
}

class _MatchFilterState extends State<MatchFilter> {
  HashSet<PracticeOption> practiceOptionsSelection = HashSet();
  HashSet<YiddishProficiency> yiddishProficiencySelection = HashSet();
  double distanceSelection = 1000;
  RangeValues ageRangeSelection = RangeValues(0, 100);

  @override
  void initState() {
    distanceSelection = widget.dataProvider.maxDistance + 0.0;
    ageRangeSelection = RangeValues(widget.dataProvider.minAge + 0.0, widget.dataProvider.maxAge + 0.0);
    for (var element in widget.dataProvider.practiceOptionsSelection) { practiceOptionsSelection.add(element);}
    for (var element in widget.dataProvider.yiddishProficiencySelection) { yiddishProficiencySelection.add(element);}
    super.initState();
  }

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
            child: Text("Filters", style: Theme.of(context).textTheme.headlineMedium,),
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
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.start,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // "Online"
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      value: practiceOptionsSelection.contains(PracticeOption.online),
                      onChanged: (bool? value) => setState(() {
                        if (value == true) {
                          practiceOptionsSelection.add(PracticeOption.online);
                        } else {
                          practiceOptionsSelection.remove(PracticeOption.online);
                        }
                        // print( "onchange 1-1!");
                      }),
                      title: Text("Online", style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ),
                  // "In-Person"
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      value: practiceOptionsSelection.contains(PracticeOption.inPerson),
                      onChanged: (bool? value) => setState(() {
                        if (value == true) {
                          practiceOptionsSelection.add(PracticeOption.inPerson);
                        } else {
                          practiceOptionsSelection.remove(PracticeOption.inPerson);
                        }
                        // print( "onchange 1-2!");
                      }),
                      title: Text("In-Person", style: Theme.of(context).textTheme.bodyMedium),
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
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.start,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // "Beginner"
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      value: yiddishProficiencySelection.contains(YiddishProficiency.beginner),
                      onChanged: (bool? value) => setState(() {
                        if (value == true) {
                          yiddishProficiencySelection.add(YiddishProficiency.beginner);
                        } else {
                          yiddishProficiencySelection.remove(YiddishProficiency.beginner);
                        }
                        // print( "onchange 2-1!");
                      }),
                      title: Text("Beginner", style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ),
                  // "Intermediate"
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      value: yiddishProficiencySelection.contains(YiddishProficiency.intermediate),
                      onChanged: (bool? value) => setState(() {
                        if (value == true) {
                          yiddishProficiencySelection.add(YiddishProficiency.intermediate);
                        } else {
                          yiddishProficiencySelection.remove(YiddishProficiency.intermediate);
                        }
                        // print( "onchange 2-2!");
                      }),
                      title: Text("Intermediate", style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ),
                  // "Proficient"
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      value: yiddishProficiencySelection.contains(YiddishProficiency.fluent),
                      onChanged: (bool? value) => setState(() {
                        if (value == true) {
                          yiddishProficiencySelection.add(YiddishProficiency.fluent);
                        } else {
                          yiddishProficiencySelection.remove(YiddishProficiency.fluent);
                        }
                        // print( "onchange 2-3!");
                      }),
                      title: Text("Fluent", style: Theme.of(context).textTheme.bodyMedium),
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
                    style: Theme.of(context).textTheme.titleMedium
                  ),
                  Text(
                    "${distanceSelection.round()} km",
                    style: Theme.of(context).textTheme.bodyMedium
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
                      style: Theme.of(context).textTheme.titleMedium
                  ),
                  Text(
                      "${(ageRangeSelection.start).round()} ~ ${(ageRangeSelection.end).round()}",
                      style: Theme.of(context).textTheme.bodyMedium
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
                onPressed: () {
                  widget.dataProvider.yiddishProficiencySelection = yiddishProficiencySelection.toList();
                  widget.dataProvider.practiceOptionsSelection = practiceOptionsSelection.toList();
                  widget.dataProvider.maxDistance = distanceSelection.round();
                  widget.dataProvider.minAge = ageRangeSelection.start.round();
                  widget.dataProvider.maxAge = ageRangeSelection.end.round();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),

      ],
    );
  }
}

