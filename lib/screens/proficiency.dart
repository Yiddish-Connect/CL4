import 'package:flutter/material.dart';

class LanguageProficiencyScreen extends StatefulWidget {
  @override
  _LanguageProficiencyScreenState createState() => _LanguageProficiencyScreenState();
}

class _LanguageProficiencyScreenState extends State<LanguageProficiencyScreen> {
  static const List<String> _proficiencyLevels = [
    'Advanced', 'Intermediate', 'Beginner'
  ];

  String? _selectedProficiency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'What is your Yiddish language proficiency?',
            style: TextStyle(color: Color.fromARGB(255, 162, 47, 145), fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Spacer(),
              Column(
                children: List.generate(_proficiencyLevels.length, (index) {
                  bool isSelected = _selectedProficiency == _proficiencyLevels[index];
                  return /*Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: */ChoiceChip(
                      label: Text(_proficiencyLevels[index]),
                      selected: isSelected,
                      selectedColor: Color.fromARGB(255, 247, 141, 231),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedProficiency = _proficiencyLevels[index];
                          } else {
                            _selectedProficiency = null;
                          }
                        });
                      },
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Color.fromARGB(255, 162, 47, 145)),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected ? Color.fromARGB(255, 247, 141, 231) : Colors.grey,
                        ),
                      ),
                    );
                  /*); */
                }),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      '3/5',
                      style: TextStyle(color: Color.fromARGB(255, 162, 47, 145), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 3 / 5,
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
    home: LanguageProficiencyScreen(),
  ));
}
