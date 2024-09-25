import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final pinkColor = Color(0xFFF02E65); // Custom pink color
  final lightGrayColor = Color(0xFFEFEFEF); // Light gray for background

  @override
  Widget build(BuildContext context) {
    final extraData = GoRouterState.of(context).extra;
    Map<String, String> userData = extraData != null && extraData is Map<String, String>
        ? extraData as Map<String, String>
        : {'profileImage': 'https://www.example.com/default-image.jpg'};
    final profileImage = userData['profileImage'] ?? 'https://www.example.com/default-image.jpg';

    return Scaffold(
      backgroundColor: lightGrayColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("My Profile", style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(profileImage),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.pink, size: 30),
                    color: pinkColor,
                    onPressed: () {
                      // TODO: Implement change profile picture
                    },
                    padding: EdgeInsets.all(5),
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "John Doe",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: pinkColor),
                    onPressed: () {
                      // TODO: Implement username editing
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Current Location: Unknown",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit_location, color: pinkColor),
                    onPressed: () {
                      // TODO: Implement location editing
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
              _buildEditableProfileInfoSection(),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement logout
                },
                child: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableProfileInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Profile Information",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _editableProfileInfo("Bio", "This is a sample bio."),
        _editableProfileInfo("Hobbies", "Reading, Traveling"),
        _editableProfileInfo("Skills", "Flutter, React, Node.js"),
      ],
    );
  }

  Widget _editableProfileInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Ensure text is visible
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: pinkColor),
            onPressed: () {
              // TODO: Implement info editing
            },
          ),
        ],
      ),
    );
  }
}
