import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ydtind/services/storage/storage_repo.dart';
import 'package:ydtind/utils/image_helper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/foundation.dart'; // Import this package

class AddPhoto extends StatefulWidget {
  const AddPhoto({super.key});

  @override
  State<AddPhoto> createState() => _AddPhotoState();
}

final imageHelper = ImageHelper();

class _AddPhotoState extends State<AddPhoto> {
  List<File?> _images = List<File?>.filled(6, null); // List for app images
  List<String?> _webImages = List<String?>.filled(6, null); // List for web images

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          height: 8.0,
          width: 8.0,
          decoration: BoxDecoration(
            color: Color.fromRGBO(253, 247, 253, 1),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 20,
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                // back to last page, TODO
              },
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(253, 247, 253, 1),
        elevation: 0,
      ),

      // main page
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(253, 247, 253, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Upload your photos',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600), // Set the max width for the grid
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final itemSize = (constraints.maxWidth - 3 * 3) / 3; // Calculate item size
                          return StaggeredGrid.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 3,
                            crossAxisSpacing: 3,
                            // create grid
                            children: List.generate(6, (index) =>
                              StaggeredGridTile.count(
                                crossAxisCellCount: index == 0 ? 2 : 1,
                                mainAxisCellCount: index == 0 ? 2 : 1,
                                child: Container(
                                  width: itemSize,
                                  height: itemSize,
                                  child: ImageTile(
                                    imageFile: _images[index],
                                    webImage: _webImages[index],
                                    onImageSelected: (file) {
                                      setState(() {
                                        if (kIsWeb) {
                                          _webImages[index] = file.path;
                                        } else {
                                          _images[index] = file;
                                        }
                                      });
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

                  SizedBox(height: 30),

                  // 'next' bottom with pop up window
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularContainer(),
                                SizedBox(height: 20),
                                Text(
                                  "You're verified",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text("Your account is verified, let's start"),
                                Text("making friends!")
                              ],
                            ),
                            actions: [
                              SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // To do forward
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromRGBO(75, 22, 26, 0.6),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(horizontal: 70, vertical: 16),
                                      textStyle: TextStyle(fontSize: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text('Get Started'),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(75, 22, 26, 0.6),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 150, vertical: 16),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Next'),
                  ),
                ],
              ),

              // progress bar
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 25, bottom: 5),
                    child: Text(
                      '5/5',
                      style: TextStyle(color: Colors.purple, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 10, bottom: 20.0),
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 30,
                      animation: false,
                      lineHeight: 10.0,
                      percent: 1,
                      barRadius: Radius.circular(10.0),
                      progressColor: Color.fromRGBO(221, 136, 207, 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// pop up window func
class CircularContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      margin: EdgeInsets.only(top: 30, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.purple.shade200,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.purple.shade100.withOpacity(0.8),
            spreadRadius: 15,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}


// image upload helper
class ImageTile extends StatelessWidget {
  final File? imageFile;
  final String? webImage; // Add a field for web image
  final ValueChanged<File> onImageSelected;

  const ImageTile({
    Key? key,
    required this.imageFile,
    required this.webImage,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey[200],
      ),
      child: Stack(
        children: [
          if (kIsWeb && webImage != null) // Check if it's web and web image is available
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                webImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          else if (imageFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.file(
                imageFile!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final files = await imageHelper.pickImage();
                if (files.isNotEmpty) {
                  final croppedFile = await imageHelper.crop(
                    file: files.first,
                    context: context,
                  );
                  if (croppedFile != null) {
                    onImageSelected(File(croppedFile.path));
                  }
                }
              },
              child: Text('Add'),
            ),
          ),
        ],
      ),
    );
  }
}
