import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final pinkColor = Color(0xFFF02E65);
  final lightGrayColor = Color(0xFFEFEFEF);

  bool isBioExpanded = false;
  bool isHobbiesExpanded = false;
  bool isSkillsExpanded = false;

  String bio = "This is a sample bio.";
  String hobbies = "Reading, Traveling";
  String skills = "Flutter, React, Node.js";

  TextEditingController bioController = TextEditingController();
  TextEditingController hobbiesController = TextEditingController();
  TextEditingController skillsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bioController.text = bio;
    hobbiesController.text = hobbies;
    skillsController.text = skills;
  }

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
                    onPressed: () {},
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
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: pinkColor),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _showPreferencesDialog,
                child: Text("Edit Preferences"),
              ),
              SizedBox(height: 30),
              _buildEditableProfileInfoSection(),
              ElevatedButton(
                onPressed: () {},
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

  void _showPreferencesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Preferences"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select your preferred options"),
              ElevatedButton(
                onPressed: _savePreferences,
                child: Text("Save Preferences"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _savePreferences() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('profiles').doc(user.uid).update({
      'preferences': {
        'example': true, // Replace with actual preferences
      },
    });
    Navigator.pop(context);
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
        _buildExpandableSection("Bio", bio, bioController, isBioExpanded, () {
          setState(() {
            isBioExpanded = !isBioExpanded;
          });
        }, Icons.person),
        _buildExpandableSection("Hobbies", hobbies, hobbiesController, isHobbiesExpanded, () {
          setState(() {
            isHobbiesExpanded = !isHobbiesExpanded;
          });
        }, Icons.spa),
        _buildExpandableSection("Skills", skills, skillsController, isSkillsExpanded, () {
          setState(() {
            isSkillsExpanded = !isSkillsExpanded;
          });
        }, Icons.code),
      ],
    );
  }

  Widget _buildExpandableSection(String title, String content, TextEditingController controller, bool isExpanded, VoidCallback onExpand, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: pinkColor, size: 24),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: pinkColor),
                onPressed: onExpand,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

