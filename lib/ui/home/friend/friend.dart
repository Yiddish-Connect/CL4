// lib/ui/home/friend/friend.dart
import 'package:flutter/material.dart';
import 'friendTitle.dart';
import '../chat/chat.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  final List<Map<String, String>> friends = [
    {'id': '10', 'name': 'Leo', 'imageUrl': 'https://example.com/leo.jpg'},
    {'id': '12', 'name': 'Bie', 'imageUrl': 'https://example.com/bie.jpg'},
    {'id': '11', 'name': 'Alan', 'imageUrl': 'https://example.com/bie.jpg'},
    // Add more friends here
  ];

  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  String _searchText = "";

  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
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
          child: Column(
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
          ),
        ),
      ),
    );
  }
}