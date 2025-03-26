import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';

class MatchPageProvider extends ChangeNotifier {
  int _maxDistance = 1000;
  int _minAge = 18;
  int _maxAge = 100;
  List<String> _practiceOptionsSelection = [];
  String _yiddishProficiencySelection = "None";

  int get maxDistance => _maxDistance;
  int get minAge => _minAge;
  int get maxAge => _maxAge;
  List<String> get practiceOptionsSelection => _practiceOptionsSelection;
  String get yiddishProficiencySelection => _yiddishProficiencySelection;

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

  void updatePracticeOptions(List<String> newSelection) {
    _practiceOptionsSelection = List.from(newSelection);
    notifyListeners();
    print("✅ Updated Practice Options: $_practiceOptionsSelection");
  }

  void setYiddishProficiency(String proficiency) {
    _yiddishProficiencySelection = proficiency;
    notifyListeners();
    print("✅ Updated Yiddish Proficiency: $_yiddishProficiencySelection");
  }

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

  Future<Set<String>> _getSwipedUserIds(String userId) async {
    final liked = await FirebaseFirestore.instance
        .collection('matches')
        .where('user1', isEqualTo: userId)
        .get();

    final reverse = await FirebaseFirestore.instance
        .collection('matches')
        .where('user2', isEqualTo: userId)
        .get();

    final Set<String> ids = {};
    for (var doc in liked.docs) {
      ids.add(doc['user2']);
    }
    for (var doc in reverse.docs) {
      ids.add(doc['user1']);
    }

    print("🧾 Already swiped users (${ids.length}): $ids");
    return ids;
  }

  Stream<List<Map<String, dynamic>>> getNearbyUsers() async* {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("🚨 No user logged in");
      yield [];
      return;
    }

    final userId = user.uid;
    final userDoc = await FirebaseFirestore.instance.collection('profiles').doc(userId).get();

    if (!userDoc.exists) {
      print("🚨 No profile found for current user");
      yield [];
      return;
    }

    final userLat = userDoc['location']?['latitude'];
    final userLon = userDoc['location']?['longitude'];

    // ✅ Parse DOB regardless of format
    DateTime? userDOB;
    var rawUserDOB = userDoc['DOB'];
    if (rawUserDOB is Timestamp) {
      userDOB = rawUserDOB.toDate();
    } else if (rawUserDOB is String) {
      userDOB = DateTime.tryParse(rawUserDOB);
    }

    final now = DateTime.now();
    final userAge = userDOB != null ? now.difference(userDOB).inDays ~/ 365 : null;

    print("🔍 Current user: $userId, Location: $userLat, $userLon, Age: $userAge");

    final alreadySwiped = await _getSwipedUserIds(userId);
    final snapshot = await FirebaseFirestore.instance.collection('profiles').get();

    List<Map<String, dynamic>> users = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final uid = data['uid'];

      print("\n🧪 Checking: ${data['name']} ($uid)");

      if (uid == userId) {
        print("❌ Skipped self");
        continue;
      }

      if (alreadySwiped.contains(uid)) {
        print("❌ Already swiped");
        continue;
      }

      final image = data['profilePhoto'] ??
          ((data['imageUrls'] is List && data['imageUrls'].isNotEmpty) ? data['imageUrls'][0] : null);

      if (image == null) {
        print("❌ No image");
        continue;
      }

      // ✅ Robust DOB parsing
      final rawDOB = data['DOB'];
      DateTime? dob;
      if (rawDOB is Timestamp) {
        dob = rawDOB.toDate();
      } else if (rawDOB is String) {
        dob = DateTime.tryParse(rawDOB);
      }

      final age = dob != null ? now.difference(dob).inDays ~/ 365 : null;
      if (age == null || age < _minAge || age > _maxAge) {
        print("❌ Age $age not in range ($_minAge–$_maxAge)");
        continue;
      }

      final prof = data['yiddishProficiency'] ?? '';
      if (_yiddishProficiencySelection != "None" &&
          prof.toLowerCase() != _yiddishProficiencySelection.toLowerCase()) {
        print("❌ Proficiency mismatch: user=$prof, filter=$_yiddishProficiencySelection");
        continue;
      }

      final practice = data['practiceOptions'] ?? [];
      if (_practiceOptionsSelection.isNotEmpty &&
          !_practiceOptionsSelection.any((opt) => practice.contains(opt))) {
        print("❌ Practice options don't match: $practice vs $_practiceOptionsSelection");
        continue;
      }

      final lat = data['location']?['latitude'];
      final lon = data['location']?['longitude'];
      bool hasLocation = lat != null && lon != null;
      double distance = hasLocation
          ? calculateDistance(userLat ?? 0, userLon ?? 0, lat, lon)
          : double.infinity;

      if (hasLocation && distance > _maxDistance) {
        print("❌ Distance $distance exceeds max $_maxDistance");
        continue;
      }

      data['distance'] = hasLocation ? distance : null;
      print("✅ Added ${data['name']} - ${data['distance']?.toStringAsFixed(1) ?? 'No Location'} miles");
      users.add(data);
    }

    print("🎯 Final match list: ${users.length} users");
    yield users;
  }
}



