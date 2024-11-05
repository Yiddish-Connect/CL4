import 'package:flutter/material.dart';
import 'friendTitle.dart';
import '../chat/chat.dart';
import 'package:yiddishconnect/services/firebaseAuthentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'friendFunction.dart';

/// A page to display the user's friends.
/// This page displays a list of the user's friends and allows the user to search for friends.
/// The user can also delete friends from their friends list.
/// If the user is not signed in, they will be prompted to sign in.
/// If the user has no friends, a message will be displayed.
class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isAnonymous = AuthService().isAnonymous();
    final userId = AuthService.getCurrentUserId();

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
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final friendIds = List<String>.from(userSnapshot.data!['friends'] ?? []);

                    if (friendIds.isEmpty) {
                      return Center(
                        child: Text('You have no friends.'),
                      );
                    }

                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where(FieldPath.documentId, whereIn: friendIds)
                          .snapshots(),
                      builder: (context, friendsSnapshot) {
                        if (!friendsSnapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final friends = friendsSnapshot.data!.docs.map((doc) {
                          final friendData = doc.data() as Map<String, dynamic>;
                          return {
                            'id': doc.id,
                            'name': friendData['displayName'] ?? 'Unknown',
                            'imageUrl': friendData['imageUrl'] ?? '',
                          };
                        }).toList();

                        final filteredFriends = friends.where((friend) {
                          return friend['name']!.toLowerCase().contains(_searchText.toLowerCase());
                        }).toList();

                        return GridView.builder(
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
                              onDelete: () async {
                                await FriendService().deleteFriend(userId, filteredFriends[index]['id']!);
                              },
                            );
                          },
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

  /// Navigates to the chat page with the given friend ID and name.
  ///
  /// \param friendId The unique identifier of the friend.
  /// \param friendName The name of the friend.
  void _navigateToChat(String friendId, String friendName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(userId: friendId, chatUser: friendName),
      ),
    );
  }
}