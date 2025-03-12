import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter/foundation.dart'; // ✅ Import for listEquals

class MatchPageProvider extends ChangeNotifier {
  int _maxDistance = 1000;
  int _minAge = 18;
  int _maxAge = 100;
  List<String> _practiceOptionsSelection = [];
  String _yiddishProficiencySelection = "None"; // Ensure it's a single string

  int get maxDistance => _maxDistance;

  int get minAge => _minAge;

  int get maxAge => _maxAge;

  List<String> get practiceOptionsSelection => _practiceOptionsSelection;

  String get yiddishProficiencySelection => _yiddishProficiencySelection;

  set maxDistance(int value) {
    if (_maxDistance != value) {
      _maxDistance = value;
      notifyListeners();
    }
  }

  set minAge(int value) {
    if (_minAge != value) {
      _minAge = value;
      notifyListeners();
    }
  }

  set maxAge(int value) {
    if (_maxAge != value) {
      _maxAge = value;
      notifyListeners();
    }
  }

  void updatePracticeOptions(List<String> newSelection) {
    if (!listEquals(_practiceOptionsSelection, newSelection)) {
      _practiceOptionsSelection = List.from(newSelection);
      notifyListeners();
      print("✅ Provider Updated Practice Options: $_practiceOptionsSelection");
    } else {
      print("❌ No Change Detected in Practice Options");
    }
  }

  void setYiddishProficiency(String proficiency) {
    if (_yiddishProficiencySelection != proficiency) {
      _yiddishProficiencySelection = proficiency;
      notifyListeners();
    }
  }

  // 🔥 Haversine Formula: Calculate distance in miles
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 3958.8; // Radius of Earth in miles
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  // ✅ Fix: Fetch Nearby Users from Firestore
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
      print("⚠️ User profile missing, showing all users...");
      yield* FirebaseFirestore.instance.collection('profiles')
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>)
              .toList());
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
}
