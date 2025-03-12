import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';
import 'package:intl/intl.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import 'package:yiddishconnect/widgets/yd_multi_steps.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yiddishconnect/utils/image_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/foundation.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

class PreferenceProvider extends ChangeNotifier {
  String _name = "";
  List<String> _selectedInterests = [];
  DateTime? _dob;
  double? _latitude;
  double? _longitude;
  double _maxDistance = 50; // Default distance in miles
  String _yiddishProficiencySelection = "None"; // Default proficiency level
  List<String> _practiceOptionsSelection = []; // Default empty practice options

  String get name => _name;
  List<String> get selectedInterests => _selectedInterests;
  DateTime? get dob => _dob;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  double get maxDistance => _maxDistance;
  String get yiddishProficiencySelection => _yiddishProficiencySelection;
  List<String> get practiceOptionsSelection => _practiceOptionsSelection;

  PreferenceProvider() {
    _loadUserData();
  }

  // 🔥 Fetch user data including new preferences
  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userId = user.uid;
    DocumentSnapshot userDoc =
    await FirebaseFirestore.instance.collection('profiles').doc(userId).get();

    if (userDoc.exists) {
      var data = userDoc.data() as Map<String, dynamic>;

      _name = data['name'] ?? "";
      _dob = data['DOB'] != null ? DateFormat('yyyy-MM-dd').parse(data['DOB']) : null;
      _selectedInterests = List<String>.from(data['Interest'] ?? []);
      _latitude = data['location']?['latitude'];
      _longitude = data['location']?['longitude'];
      _maxDistance = (data['maxDistance'] ?? 50).toDouble();

      // ✅ Fix: Ensure yiddishProficiency is stored as a SINGLE String
      _yiddishProficiencySelection = data['yiddishProficiency'] ?? "None";

      // ✅ Fix: Ensure practiceOptions is still a LIST
      _practiceOptionsSelection = List<String>.from(data['practiceOptions'] ?? []);

      print("Loaded practiceOptions: $_practiceOptionsSelection");
      print("Loaded yiddishProficiency: $_yiddishProficiencySelection");

      notifyListeners();
    }
  }



  set name(String name) {
    _name = name;
    notifyListeners();
  }

  set dob(DateTime? date) {
    _dob = date;
    notifyListeners();
  }

  void addInterest(String interest) {
    _selectedInterests.add(interest);
    notifyListeners();
  }

  void removeInterest(String interest) {
    _selectedInterests.remove(interest);
    notifyListeners();
  }

  void updateLocation(double lat, double lng) {
    _latitude = lat;
    _longitude = lng;
    notifyListeners();
  }

  set maxDistance(double value) {
    _maxDistance = value;
    notifyListeners();
  }

  set yiddishProficiencySelection(String value) {
    _yiddishProficiencySelection = value;
    notifyListeners();
  }

  set practiceOptionsSelection(List<String> value) {
    if (_practiceOptionsSelection != value) {  // ✅ Check if values changed first
      _practiceOptionsSelection = value;
      notifyListeners();
    } else {
      debugPrint("❌ No Change: practiceOptionsSelection = $_practiceOptionsSelection");
    }
  }



}





class PreferenceScreen extends StatelessWidget {
  const PreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PreferenceProvider(),
      child: Consumer<PreferenceProvider>(
        builder: (context, preferenceProvider, child) {
          return MultiSteps(
            title: "Preference",
            hasButton: true,
            hasProgress: true,
            onComplete: () async {
              final name = preferenceProvider.name.trim();
              final dob = preferenceProvider.dob;
              final interests = preferenceProvider.selectedInterests;
              final latitude = preferenceProvider.latitude;
              final longitude = preferenceProvider.longitude;
              final proficiency = preferenceProvider.yiddishProficiencySelection;
              final practiceOptions = preferenceProvider.practiceOptionsSelection;

              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter your name")));
                return;
              }

              if (dob == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select your Date of Birth")));
                return;
              }

              if (interests.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select at least one interest")));
                return;
              }

              if (latitude == null || longitude == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select a location")));
                return;
              }

              if (proficiency.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select your proficiency level")));
                return;
              }

              if (practiceOptions.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select at least one practice option")));
                return;
              }

              User? user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("User not logged in")));
                return;
              }

              String userId = user.uid;

              try {
                await FirebaseFirestore.instance.collection('profiles').doc(userId).set({
                  'name': name,
                  'DOB': DateFormat('yyyy-MM-dd').format(dob),
                  'Interest': interests,
                  'location': {
                    'latitude': latitude,
                    'longitude': longitude
                  },
                  'maxDistance': preferenceProvider.maxDistance,
                  'yiddishProficiency': proficiency,
                  'practiceOptions': practiceOptions,
                  'uid': userId,
                  'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
                }, SetOptions(merge: true));

                _dialogBuilder(context);
              } catch (e) {
                print("Error updating Firestore: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error updating profile")));
              }
            },
            steps: [
              OneStep(title: "What's your name?", builder: (prev, next) => _Step1()),
              OneStep(title: "When is your Birthday?", builder: (prev, next) => _Step5()),
              OneStep(title: "Location", builder: (prev, next) => _Step2()),
              OneStep(title: "Select up to 5 interests", builder: (prev, next) => _Step3()),
              OneStep(title: "Upload your photos", builder: (prev, next) => _Step4()),
              OneStep(title: "Set max distance", builder: (prev, next) => _Step6()),
              OneStep(title: "Select proficiency level", builder: (prev, next) => _Step7()), // ✅ NEW
              OneStep(title: "Select practice options", builder: (prev, next) => _Step8()), // ✅ NEW
            ],
          );
        },
      ),
    );
  }
}



  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: 450,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).colorScheme.surface,
          ),
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.check,
                            color: Theme.of(context).colorScheme.surface))
                  ],
                ),
              ),
              Text(
                "You're Verified",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: 250,
                ),
                child: Text(
                  "Your account is verified. Let's start to make friends!",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 50,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => context.go("/"),
                      child: Text("Get Started")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


// What's your name
class _Step1 extends StatefulWidget {
  @override
  _Step1State createState() => _Step1State();
}

class _Step1State extends State<_Step1> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    final preferenceProvider = Provider.of<PreferenceProvider>(context, listen: false);
    nameController = TextEditingController(text: preferenceProvider.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceProvider>(
      builder: (context, preferenceProvider, child) {
        return Container(
          padding: const EdgeInsets.all(30),
          constraints: const BoxConstraints(
            maxHeight: 300,
            maxWidth: 300,
          ),
          child: TextFormField(
            controller: nameController,
            onChanged: (value) {
              if (preferenceProvider.name != value.trim()) {
                preferenceProvider.name = value.trim();
              }
            },
            maxLength: 70,
            decoration: const InputDecoration(
              labelText: "Enter your name",
              border: OutlineInputBorder(),
            ),
          ),
        );
      },
    );
  }
}


// Location
class _Step2 extends StatefulWidget {
  const _Step2();

  @override
  _Step2State createState() => _Step2State();
}

class _Step2State extends State<_Step2> {
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PreferenceProvider>(context, listen: false);
      if (provider.latitude != null && provider.longitude != null) {
        setState(() {
          selectedLocation = LatLng(provider.latitude!, provider.longitude!);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 400,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: selectedLocation ?? LatLng(37.7749, -122.4194),
              initialZoom: 10,
              onTap: (tapPosition, point) {
                setState(() {
                  selectedLocation = point;
                });
                Provider.of<PreferenceProvider>(context, listen: false).updateLocation(point.latitude, point.longitude);
              },
            ),
            children: [
              TileLayer(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
              if (selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: selectedLocation!,
                      child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                    ),
                  ],
                ),
            ],
          ),
        ),

    ElevatedButton(
    onPressed: () async {
    if (selectedLocation != null) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
    await FirebaseFirestore.instance.collection('profiles').doc(user.uid).update({
    'location': {
    'latitude': selectedLocation!.latitude,
    'longitude': selectedLocation!.longitude,
    },
    });

    print("Location saved to Firestore: Latitude = ${selectedLocation!.latitude}, Longitude = ${selectedLocation!.longitude}");
    }
    } else {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Please select a location first.")));
    }
    },
    child: Text("Confirm Location"),
    ),
      ],
    );
  }
}

// Select up to 5 interests
class _Step3 extends StatelessWidget {
  const _Step3();

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
                      //Provider.of<PreferenceProvider>(context, listen: false).//UploadData(_interests[index],'interests');
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
            "${Provider.of<PreferenceProvider>(context, listen: true).selectedInterests.length}/5 selected",
            style: TextStyle(color: Colors.purple, fontSize: 16),
          ),
        ],
      ),
    );
  }
}


// Upload your photos
class _Step4 extends StatefulWidget {
  const _Step4();

  @override
  State<_Step4> createState() => _Step4State();
}

class _Step4State extends State<_Step4> {
  List<File?> _images = List<File?>.filled(6, null); // List for app images
  List<Uint8List?> _webImages = List<Uint8List?>.filled(6, null); // List for web images

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16), // Add padding to avoid edge issues
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400), // Set max width for the grid
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemSize = (constraints.maxWidth - 3 * 3) / 3; // Calculate item size
                    return StaggeredGrid.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      children: List.generate(6, (index) =>
                          StaggeredGridTile.count(
                            crossAxisCellCount: index == 0 ? 2 : 1,
                            mainAxisCellCount: index == 0 ? 2 : 1,
                            child: SizedBox(
                              width: itemSize,
                              height: itemSize,
                              child: ImageTile(
                                imageFile: _images[index],
                                webImage: _webImages[index],
                                onImageSelected: (file) {
                                  setState(() {
                                    if (kIsWeb) {
                                      _webImages[index] = file;
                                    } else {
                                      _images[index] = file;
                                    }
                                  });

// ✅ Notify provider that an image is added
                                  Provider.of<PreferenceProvider>(context, listen: false).notifyListeners();

                                },
                              ),
                            ),
                          ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20), // Add spacing at the bottom
          ],
        ),
      ),
    );
  }
}

// Image upload helper widget
class ImageTile extends StatelessWidget {
  final File? imageFile;
  final Uint8List? webImage; // Add a field for web image
  final ValueChanged<dynamic> onImageSelected;

  const ImageTile({
    super.key,
    required this.imageFile,
    required this.webImage,
    required this.onImageSelected,
  });

  Future<void> uploadImageAndStoreInFirestore(dynamic file, String userId) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('user_uploads/$userId/$fileName');


      UploadTask uploadTask;
      SettableMetadata metadata = SettableMetadata(contentType: "image/jpeg");

      if (kIsWeb) {
        Uint8List fileBytes = file;
        uploadTask = storageRef.putData(fileBytes, metadata);
      } else {
        File mobileFile = file;
        uploadTask = storageRef.putFile(mobileFile, metadata);
      }

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // ✅ Ensure Image URL is stored in Firestore
      await FirebaseFirestore.instance.collection('profiles').doc(userId).update({
        'imageUrls': FieldValue.arrayUnion([downloadUrl]),
      });

      print("Image uploaded successfully: $downloadUrl");
    } catch (e) {
      print('Error uploading image: $e');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200],
      ),
      child: Stack(
        children: [
          if (kIsWeb && webImage != null)  // Check if it's web and web image is available
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.memory(
                webImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          else if (imageFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                imageFile!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter, // Position at the bottom center
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
    onPressed: () async {
    try {
    final files = await ImageHelper().pickImage();
    if (files.isNotEmpty) {
    final croppedFile = await ImageHelper().crop(
    file: files.first,
    context: context,
    );
    if (croppedFile != null) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
    String userId = user.uid;
    if (kIsWeb) {
    Uint8List fileBytes = await files.first.readAsBytes();
    onImageSelected(fileBytes);
    await uploadImageAndStoreInFirestore(fileBytes, userId);  // ✅ Use correct function
    } else {
    File imageFile = File(croppedFile.path);
    onImageSelected(imageFile);
    await uploadImageAndStoreInFirestore(imageFile, userId);  // ✅ Use correct function
    }
    }
    }
    }
    } catch (e) {
    print('$e');
    }
    },



                child: Text('Add'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Step5 extends StatefulWidget {
  @override
  _Step5State createState() => _Step5State();
}

class _Step5State extends State<_Step5> {
  DateTime? _selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      // Update the DOB in PreferenceProvider
      Provider.of<PreferenceProvider>(context, listen: false).dob = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () => _pickDate(context),
            child: Text(
              _selectedDate == null
                  ? 'Select Date of Birth'
                  : 'Date of Birth: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
            ),
          ),
          SizedBox(height: 20),
          // Other widgets can go here
        ],
      ),
    );
  }
}

class _Step6 extends StatefulWidget {
  @override
  _Step6State createState() => _Step6State();
}

class _Step6State extends State<_Step6> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceProvider>(
      builder: (context, preferenceProvider, child) {
        return Column(
          children: [
            Text(
              "Max Distance: ${preferenceProvider.maxDistance == 1000 ? "No Limit" : "${preferenceProvider.maxDistance.toInt()} miles"}",
              style: TextStyle(fontSize: 18),
            ),
            Slider(
              value: preferenceProvider.maxDistance,
              min: 0,
              max: 1000,
              divisions: 100,
              label: preferenceProvider.maxDistance == 1000
                  ? "No Limit"
                  : "${preferenceProvider.maxDistance.toInt()} miles",
              onChanged: (value) {
                preferenceProvider.maxDistance = value;
              },
            ),
          ],
        );
      },
    );
  }
}

class _Step7 extends StatefulWidget {
  @override
  State<_Step7> createState() => _Step7State();
}

class _Step7State extends State<_Step7> {
  List<String> proficiencyLevels = ["None", "Novice", "Intermediate", "Advanced/Fluent"];
  String _selectedProficiency = "None";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Select Your Yiddish Proficiency"),
        Wrap(
          spacing: 10,
          children: proficiencyLevels.map((level) {
            return ChoiceChip(
              label: Text(level),
              selected: _selectedProficiency == level,
              onSelected: (selected) {
                setState(() {
                  _selectedProficiency = level;
                  Provider.of<PreferenceProvider>(context, listen: false).yiddishProficiencySelection = level;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _Step8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("How Do You Prefer to Practice?"),
        Wrap(
          spacing: 10,
          children: ["Remote", "In-Person", "Hybrid"].map((option) {

            return ChoiceChip(
              label: Text(option),
              selected: Provider.of<PreferenceProvider>(context).practiceOptionsSelection.contains(option),
              onSelected: (selected) {
                var provider = Provider.of<PreferenceProvider>(context, listen: false);
                provider.practiceOptionsSelection = selected
                    ? [...provider.practiceOptionsSelection, option]
                    : provider.practiceOptionsSelection..remove(option);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

