import 'dart:collection';
import 'package:flutter/material.dart';
import '../../models/filter.dart';

class MatchPageProvider extends ChangeNotifier {
  List<PracticeOption> _practiceOptionsSelection = [];
  List<YiddishProficiency> _yiddishProficiencySelection = [];
  int _minDistance = 0;
  int _maxDistance = 1000;
  int _minAge = 0;
  int _maxAge = 100;

  List<PracticeOption> get practiceOptionsSelection => _practiceOptionsSelection;

  set practiceOptionsSelection(List<PracticeOption> value) {
    _practiceOptionsSelection = value;
    notifyListeners();
  }

  int get maxAge => _maxAge;

  set maxAge(int value) {
    _maxAge = value;
    notifyListeners();
  }

  int get minAge => _minAge;

  set minAge(int value) {
    _minAge = value;
    notifyListeners();
  }

  int get maxDistance => _maxDistance;

  set maxDistance(int value) {
    _maxDistance = value;
    notifyListeners();
  }

  int get minDistance => _minDistance;

  set minDistance(int value) {
    _minDistance = value;
    notifyListeners();
  }

  List<YiddishProficiency> get yiddishProficiencySelection => _yiddishProficiencySelection;

  set yiddishProficiencySelection(List<YiddishProficiency> value) {
    _yiddishProficiencySelection = value;
    notifyListeners();
  }
}