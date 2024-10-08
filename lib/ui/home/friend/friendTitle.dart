// lib/ui/home/friend/friend_tile.dart
import 'package:flutter/material.dart';

class FriendTile extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onTap;
  const FriendTile({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 30,
            ),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}