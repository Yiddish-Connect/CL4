import 'package:flutter/material.dart';

class InterestsScreen extends StatefulWidget {
  @override
  _InterestsScreenState createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final List<String> _interests = [
    'Gaming', 'Dancing', 'Language', 'Music', 'Movie',
    'Photography', 'Architecture', 'Fashion', 'Book',
    'Writing', 'Nature', 'Painting', 'Football', 'People',
    'Animals', 'Gym & Fitness'
  ];

  final List<IconData> _icons = [
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
        backgroundColor: Colors.purple,
        title: Text('Select up to 5 interests'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: List.generate(_interests.length, (index) {
                bool isSelected = _selectedInterests.contains(_interests[index]);
                return ChoiceChip(
                  label: Text(_interests[index]),
                  avatar: Icon(_icons[index], color: isSelected ? Colors.white : Colors.purple),
                  selected: isSelected,
                  selectedColor: Colors.purple,
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
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.purple),
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: isSelected ? Colors.purple : Colors.grey,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            Text(
              '${_selectedInterests.length}/5 selected',
              style: TextStyle(color: Colors.purple, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: InterestsScreen(),
//   ));
// }
