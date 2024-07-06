import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import 'package:yiddishconnect/widgets/yd_multi_steps.dart';

class PreferenceProvider extends ChangeNotifier {
  String _name = "";
  String get name => _name;
  set name (String name) {
    _name = name;
    print("NOTIFY");
    notifyListeners();
  }

  List<String> _selectedInterests = [];
  List<String> get selectedInterests => _selectedInterests;
  void addInterest(String interest) {
    _selectedInterests.add(interest);
    notifyListeners();
  }
  void removeInterest(String interest) {
    _selectedInterests.remove(interest);
    notifyListeners();
  }
}

class PreferenceScreen extends StatelessWidget {
  const PreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PreferenceProvider(),
      child: MultiSteps(
        title: "Preference",
        hasButton: true,
        hasProgress: true,
        steps: [
          OneStep(title: "What's your name?", builder: (callback) => _Step1(action: callback)),
          OneStep(title: "Location", builder: (callback) => _Step2(action: callback)),
          OneStep(title: "Select up to 5 interests", builder: (callback) => _Step3(action: callback)),
          OneStep(title: "Upload your photos", builder: (callback) => _Step4(action: () {
            // TODO: Show a 'you are Verified' modal instead
            toast(context, "You are verified");
            context.go("/home");
          })),
        ],
      ),
    );
  }
}

// What's your name
class _Step1 extends ActionWidget {
  _Step1 ({super.key, required super.action});
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print("rebuild...  the value is ${nameController.value} ");
    return Consumer<PreferenceProvider>(
      builder: (BuildContext context, PreferenceProvider preferenceProvider, Widget? child) {
        // print("Assign the name from provider to textfield: ${Provider.of<PreferenceProvider>(context, listen: false).name} => ${nameController.text}");
        nameController.text = Provider.of<PreferenceProvider>(context, listen: false).name;
        return Container(
            padding: EdgeInsets.all(30),
            constraints: BoxConstraints(
                maxHeight: 300,
                maxWidth: 300
            ),
            color: Colors.red,
            child: TextField(
              controller: nameController,
              onChanged: (value) {
                print("OnChange... value is ${value}");
                Provider.of<PreferenceProvider>(context, listen: false).name = value;
              },
            )
        );
      },
    );
  }
}
// abcd
// abcd

// Location
class _Step2 extends ActionWidget {
  const _Step2({super.key, required super.action});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// Select up to 5 interests
class _Step3 extends ActionWidget {
  const _Step3({super.key, required super.action});

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

  @override
  Widget build(BuildContext context) {
    // print("rebuild!!");
    return Container(
      constraints: BoxConstraints(
        maxWidth: 600
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: List.generate(_interests.length, (index) {
              return Consumer<PreferenceProvider>(
                builder: (BuildContext context, PreferenceProvider preferenceProvider, Widget? child) {
                  bool isSelected = context.read<PreferenceProvider>().selectedInterests.contains(_interests[index]);
                  return ChoiceChip(
                    label: Text(_interests[index]),
                    avatar: Icon(_icons[index], color: isSelected ? Colors.white : Colors.purple),
                    selected: isSelected,
                    selectedColor: Colors.purple,
                    onSelected: (selected) {
                      if (selected && preferenceProvider.selectedInterests.length < 5) {
                        preferenceProvider.addInterest(_interests[index]);
                      } else if (!selected) {
                        preferenceProvider.removeInterest(_interests[index]);
                      }
                    },
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.purple),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: isSelected ? Colors.purple : Colors.grey,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          SizedBox(height: 20),
          Text(
            "${Provider.of<PreferenceProvider>(context, listen: false).selectedInterests.length}/5 selected",
            style: TextStyle(color: Colors.purple, fontSize: 16),
          ),
        ],
      ),
    );
  }
}


// Upload your photos
class _Step4 extends ActionWidget {
  const _Step4({super.key, required super.action});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
