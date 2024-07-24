import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ydtind/services/storage/storage_repo.dart';
import 'package:ydtind/utils/image_helper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:yiddishconnect/utils/image_helper.dart'; // Import this package

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
                ],
              ),

              // progress bar
              
            ],
          ),
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
