import 'package:flutter/material.dart';
import 'friendTitle.dart';
import '../chat/chat.dart';
import 'package:yiddishconnect/services/firebaseAuthentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  List<Map<String, String>> friends = [];
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
    _fetchFriends();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchFriends() async {
    final userId = AuthService.getCurrentUserId(); // Accessing the static method correctly
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final friendIds = List<String>.from(userDoc['friends'] ?? []);

    final friendsData = await Future.wait(friendIds.map((id) async {
      final friendDoc = await FirebaseFirestore.instance.collection('users').doc(id).get();
      final friendData = friendDoc.data() as Map<String, dynamic>;
      return {
        'id': id,
        'name': friendData['displayName'] ?? 'Unknown', // Handle missing 'displayName' field
        'imageUrl': friendData['imageUrl'] ?? '', // Handle missing 'imageUrl' field
      };
    }));

    setState(() {
      friends = friendsData.map((friend) => friend.cast<String, String>()).toList();
    });
  }

  void _navigateToChat(String friendId, String friendName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(userId: friendId, chatUser: friendName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAnonymous = AuthService().isAnonymous();

    List filteredFriends = friends.where((friend) {
      return friend['name']!.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: !isAnonymous
              ? Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search friends...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: filteredFriends.length,
                  itemBuilder: (context, index) {
                    return FriendTile(
                      name: filteredFriends[index]['name']!,
                      imageUrl: filteredFriends[index]['imageUrl']!,
                      onTap: () {
                        _navigateToChat(
                          filteredFriends[index]['id']!,
                          filteredFriends[index]['name']!,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('You need to sign in to view friends'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.go("/auth");
                  },
                  child: Text('Sign in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}