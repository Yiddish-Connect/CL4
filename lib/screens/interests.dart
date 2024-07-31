import 'package:flutter/material.dart';

class InterestsScreen extends StatefulWidget {
  @override
  _InterestsScreenState createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  static const List<String> _interests = [
    'Gaming', 'Dancing', 'Language', 'Music', 'Movie',
    'Photography', 'Architecture', 'Fashion', 'Book',
    'Writing', 'Nature', 'Painting', 'Football', 'People',
    'Animals', 'Gym & Fitness'
  ];

  static const List<IconData> _icons = [
    Icons.videogame_asset, Icons.directions_run, Icons.language,
    Icons.music_note, Icons.movie, Icons.camera_alt, Icons.account_balance,
    Icons.checkroom, Icons.book, Icons.edit, Icons.eco, Icons.brush,
    Icons.sports_soccer, Icons.people, Icons.pets, Icons.fitness_center
  ];

  List<String> _selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Select up to 5 interests',
          style: TextStyle(color: Color.fromARGB(255, 162, 47, 145), fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                alignment: WrapAlignment.center,
                children: List.generate(_interests.length, (index) {
                  bool isSelected = _selectedInterests.contains(_interests[index]);
                  return ChoiceChip(
                    label: Text(_interests[index]),
                    avatar: Icon(_icons[index], color: isSelected ? Colors.black : Colors.black),
                    selected: isSelected,
                    selectedColor: Color.fromARGB(255, 247, 141, 231),
                    onSelected: (selected) {
                      setState(() {
                        if (selected && _selectedInterests.length < 5) {
                          _selectedInterests.add(_interests[index]);
                        } else if (!selected) {
                          _selectedInterests.remove(_interests[index]);
                        }
                      });
                    },
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Color.fromARGB(255, 162, 47, 145), fontSize: 16),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: isSelected ? Color.fromARGB(255, 247, 141, 231) : Colors.grey,
                      ),
                    ),
                  );
                }),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      '4/5',
                      style: TextStyle(color: Color.fromARGB(255, 162, 47, 145), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 4 / 5,
                      backgroundColor: Color.fromARGB(255, 254, 196, 247),
                      color: Color.fromARGB(255, 247, 141, 231),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: InterestsScreen(),
  ));
}
