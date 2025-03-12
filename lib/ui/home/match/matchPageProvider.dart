import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class MatchPageProvider extends ChangeNotifier {
  int _maxDistance = 1000;
  int _minAge = 18;  // Default min age
  int _maxAge = 100; // Default max age
  List<String> _practiceOptionsSelection = [];
  List<String> _yiddishProficiencySelection = [];

  int get maxDistance => _maxDistance;
  int get minAge => _minAge;
  int get maxAge => _maxAge;
  List<String> get practiceOptionsSelection => _practiceOptionsSelection;
  List<String> get yiddishProficiencySelection => _yiddishProficiencySelection;

  set maxDistance(int value) {
    _maxDistance = value;
    notifyListeners();
  }

  set minAge(int value) {
    _minAge = value;
    notifyListeners();
  }

  set maxAge(int value) {
    _maxAge = value;
    notifyListeners();
  }

  set practiceOptionsSelection(List<String> value) {
    _practiceOptionsSelection = value;
    notifyListeners();
  }

  set yiddishProficiencySelection(List<String> value) {
    _yiddishProficiencySelection = value;
    notifyListeners();
  }

  // Haversine Formula: Calculate distance in miles
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 3958.8;
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  // Fetch Nearby Users from Firestore
  Stream<List<Map<String, dynamic>>> getNearbyUsers() async* {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      yield [];
      return;
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      yield [];
      return;
    }

    double? userLat = userDoc['location']?['latitude'];
    double? userLon = userDoc['location']?['longitude'];

    if (userLat == null || userLon == null) {
      yield [];
      return;
    }

    List<Map<String, dynamic>> users = [];

    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('profiles').get();

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['uid'] == user.uid) continue;

      double? lat = data['location']?['latitude'];
      double? lon = data['location']?['longitude'];

      if (lat != null && lon != null) {
        double distance = calculateDistance(userLat, userLon, lat, lon);

        if (_maxDistance == 1000 || distance <= _maxDistance) {
          data['distance'] = distance;
          users.add(data);
        }
      }
    }

    users.sort((a, b) => a['distance'].compareTo(b['distance']));
    yield users;
  }

  // Calculate Age from DOB
  int? calculateAge(String? dobString) {
    if (dobString == null) return null;
    DateTime dob = DateTime.parse(dobString);
    DateTime now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }
}
