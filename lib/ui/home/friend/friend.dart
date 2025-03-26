
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  List<Map<String, dynamic>> friends = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFriends();
  }

  Future<void> loadFriends() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userId = user.uid;
    final firestore = FirebaseFirestore.instance;

    final matchSnapshot = await firestore
        .collection('matches')
        .where('status', isEqualTo: 1)
        .get();

    final matchedUserIds = matchSnapshot.docs.map((doc) {
      final data = doc.data();
      if (data['user1'] == userId) return data['user2'];
      if (data['user2'] == userId) return data['user1'];
      return null;
    }).whereType<String>().toSet();

    if (matchedUserIds.isEmpty) {
      setState(() {
        friends = [];
        isLoading = false;
      });
      return;
    }

    final profileSnapshot = await firestore.collection('profiles').get();
    final allProfiles = profileSnapshot.docs.map((doc) => doc.data()).toList();

    final matchedProfiles = allProfiles
        .where((profile) => matchedUserIds.contains(profile['uid']))
        .toList();

    setState(() {
      friends = matchedProfiles;
      isLoading = false;
    });
  }

  Widget _buildFriendTile(Map<String, dynamic> friend) {
    final String name = friend['name'] ?? 'Unnamed';
    final String? photo = (friend['imageUrls'] is List && friend['imageUrls'].isNotEmpty)
        ? friend['imageUrls'][0]
        : null;

    return ExpansionTile(
      leading: photo != null
          ? FutureBuilder<String>(
        future: FirebaseStorage.instance.ref(photo).getDownloadURL(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircleAvatar(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const CircleAvatar(child: Icon(Icons.error));
          }
          return CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data!),
          );
        },
      )
          : const CircleAvatar(child: Icon(Icons.person)),
      title: Text(name),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (friend['yiddishProficiency'] != null)
                Text("Yiddish Proficiency: ${friend['yiddishProficiency']}"),
              if (friend['practiceOptions'] != null)
                Text("Practice Options: ${friend['practiceOptions'].join(', ')}"),
              if (friend['Interest'] != null)
                Text("Interests: ${friend['Interest'].join(', ')}"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to chat or profile action
                },
                child: const Text("Message"),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friends')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : friends.isEmpty
          ? const Center(child: Text("No friends found."))
          : ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return _buildFriendTile(friends[index]);
        },
      ),
    );
  }
}
