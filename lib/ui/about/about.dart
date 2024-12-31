import 'package:flutter/material.dart';

// TODO: Replace items with members working on the project
final List<String> items = ["Person 1", "Person 2", "Person 3", "Person 4", "Person 5"];

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF), // Light gray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("About", style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    ImageIcon(
                      AssetImage("assets/google_icon@2x.png"),
                      color: null,
                      size: 100,
                    ),
                    Text(
                      "CL4",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "app version",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                )
              ),
              SizedBox(height: 25),
              Text(
                "About the project",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                // TODO: Replace with description text
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus eget orci eu lacus porttitor "
                "imperdiet. Vivamus consequat urna purus, ut facilisis magna eleifend sit amet. In suscipit "
                "dictum elit, gravida ullamcorper sem. Integer fermentum aliquam libero, at dapibus enim ",
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 25),
              Text(
                "Contributors",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.black), // Icon as bullet
                      SizedBox(width: 8),
                      Expanded(child: Text(items[index])),
                    ],
                  );
                }
              ),
              SizedBox(height: 25),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Redirect user to donation page
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 40),
                      ),
                      child: Text("Donate"),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Redirect user to main website
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 40),
                      ),
                      child: Text("Our website"),
                    )
                  ]
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}


