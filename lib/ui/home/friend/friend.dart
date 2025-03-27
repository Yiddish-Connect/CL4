
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late Future<List<Map<String, dynamic>>> _friendsFuture;

  @override
  void initState() {
    super.initState();
    _friendsFuture = _loadFriends();
  }

  Future<String> _getImageUrl(String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      return "";
    }
  }

  Future<List<Map<String, dynamic>>> _loadFriends() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final userId = user.uid;

    final matchesSnapshot = await FirebaseFirestore.instance
        .collection('matches')
        .where('status', isEqualTo: 1)
        .get();

    final matchedUserIds = <String>{};
    for (var doc in matchesSnapshot.docs) {
      final data = doc.data();
      if (data['user1'] == userId) {
        matchedUserIds.add(data['user2']);
      } else if (data['user2'] == userId) {
        matchedUserIds.add(data['user1']);
      }
    }

    if (matchedUserIds.isEmpty) return [];

    final profilesSnapshot =
    await FirebaseFirestore.instance.collection('profiles').get();

    List<Map<String, dynamic>> matchedProfiles = [];
    for (var doc in profilesSnapshot.docs) {
      final data = doc.data();
      if (matchedUserIds.contains(data['uid'])) {
        matchedProfiles.add(data);
      }
    }

    return matchedProfiles;
  }

  Widget _buildFriendTile(Map<String, dynamic> profile) {
    final name = profile['name'] ?? 'Unknown';
    final dobRaw = profile['DOB'];
    DateTime? dob = dobRaw is Timestamp
        ? dobRaw.toDate()
        : (dobRaw is String ? DateTime.tryParse(dobRaw) : null);
    final age = dob != null
        ? (DateTime.now().difference(dob).inDays ~/ 365).toString()
        : 'N/A';

    final uid = profile['uid'] ?? '';
    final imageUrls = profile['imageUrls'] ?? [];
    final imagePath = (imageUrls is List && imageUrls.isNotEmpty)
        ? imageUrls[0]
        : profile['profilePhoto'] ?? '';
    final distance = profile['distance']?.toStringAsFixed(1) ?? 'N/A';
    final yiddish = profile['yiddishProficiency'] ?? 'Unknown';
    final practiceOptions =
        (profile['practiceOptions'] as List?)?.join(', ') ?? 'None listed';
    final interests =
        (profile['Interest'] as List?)?.join(', ') ?? 'None listed';
    final bio = profile['bio'] ?? 'No bio available';

    return FutureBuilder<String>(
      future: _getImageUrl(imagePath),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data ?? "";

        return ExpansionTile(
          leading: CircleAvatar(
            backgroundImage:
            imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            child: imageUrl.isEmpty ? Icon(Icons.person) : null,
          ),
          title: Text(name),
          subtitle: Text('Distance: $distance miles'),
          children: [
            ListTile(title: Text("Age: $age")),
            ListTile(title: Text("Fluency: $yiddish")),
            ListTile(title: Text("Practice: $practiceOptions")),
            ListTile(title: Text("Interests: $interests")),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Bio: $bio"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Friends')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _friendsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final friends = snapshot.data ?? [];
          if (friends.isEmpty) {
            return const Center(child: Text("No friends found."));
          }

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return _buildFriendTile(friends[index]);
            },
          );
        },
      ),
    );
  }
}
