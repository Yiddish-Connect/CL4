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

  // Track the rotation state and text for each section
  bool isBioExpanded = false;
  bool isHobbiesExpanded = false;
  bool isSkillsExpanded = false;

  String bio = "This is a sample bio.";  // Bio content
  String hobbies = "Reading, Traveling";  // Hobbies content
  String skills = "Flutter, React, Node.js";  // Skills content

  TextEditingController bioController = TextEditingController();
  TextEditingController hobbiesController = TextEditingController();
  TextEditingController skillsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bioController.text = bio;  // Initialize text field with bio content
    hobbiesController.text = hobbies;  // Initialize text field with hobbies content
    skillsController.text = skills;  // Initialize text field with skills content
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
        // Use appropriate icons for each section
        _buildExpandableSection("Bio", bio, bioController, isBioExpanded, () {
          setState(() {
            isBioExpanded = !isBioExpanded;
          });
        }, Icons.person),  // Bio icon

        _buildExpandableSection("Hobbies", hobbies, hobbiesController, isHobbiesExpanded, () {
          setState(() {
            isHobbiesExpanded = !isHobbiesExpanded;
          });
        }, Icons.spa),  // Hobbies icon

        _buildExpandableSection("Skills", skills, skillsController, isSkillsExpanded, () {
          setState(() {
            isSkillsExpanded = !isSkillsExpanded;
          });
        }, Icons.code),  // Skills icon
      ],
    );
  }

  // Build expandable sections for bio, hobbies, and skills with individual icons
  Widget _buildExpandableSection(String title, String content, TextEditingController controller, bool isExpanded, VoidCallback onExpand, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: pinkColor, size: 24),  // Use the passed icon
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              IconButton(
                icon: AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,  // Rotate to down when expanded
                  duration: Duration(milliseconds: 200),
                  child: Icon(Icons.chevron_right, color: pinkColor),
                ),
                onPressed: onExpand,
              ),
            ],
          ),
          // Always visible content
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Text(
              controller.text, // Always show the updated content
              style: TextStyle(fontSize: 16, color: Colors.black),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isExpanded) ...[
            SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Edit $title',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (title == "Bio") bio = controller.text;
                      if (title == "Hobbies") hobbies = controller.text;
                      if (title == "Skills") skills = controller.text;
                      onExpand();
                    });
                  },
                  child: Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      controller.text = content; // Reset the text field to current content
                      onExpand();  // Collapse without saving
                    });
                  },
                  child: Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}

