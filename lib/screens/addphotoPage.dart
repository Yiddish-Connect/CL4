import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ydtind/services/storage/storage_repo.dart';
import '../services/auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AddPhoto extends StatefulWidget {
  const AddPhoto({super.key});

  @override
  State<AddPhoto> createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto>{
  List<String> images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leadingWidth: 80,
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
      
      body: Container(
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
                Padding( 
                  padding:EdgeInsets.all(10.0),

                  child: StaggeredGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    children: [
                      StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 2,

                        child: Container(
                          margin: EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.grey[200],
                          ),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50,
                                );

                                if (image == null && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('No image was selected.')));
                                }


                                if (image != null && mounted) {

                                  CroppedFile? croppedFile = await ImageCropper().cropImage(
                                    sourcePath: image.path,
                                    aspectRatio: const CropAspectRatio(
                                      ratioX: 9,
                                      ratioY: 16
                                    ),
                                    // aspectRatioPresets: [],
                                    uiSettings: [
                                      AndroidUiSettings(
                                        toolbarTitle: 'Cropper',
                                        initAspectRatio: CropAspectRatioPreset.original,
                                        lockAspectRatio: false
                                      ),

                                    ]
                                  );
                                  // print('Uploading ...');
                                  // StorageRepo().uploadImage(image.path);
                                  if (croppedFile != null && mounted) {
                                    setState(() {
                                      images.add(croppedFile.path);
                                    });
                                    await Future.delayed((Duration(milliseconds: 100)));
                                    if (mounted){
                                      Navigator.pop(context, images);
                                    }
                                  }
                                  
                                  
                                }
                              },
                              child: Text('Change Picture'),
                            ),
                          ),

                        ),
                      ),

                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Container(
                          margin: EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.grey[200],
                          ),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                              
                              },
                              child: Text('Add'),
                            ),
                          ),

                        ),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Container(
                          margin: EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.grey[200],
                          ),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                              
                              },
                              child: Text('Add'),
                            ),
                          ),

                        ),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Container(
                          margin: EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.grey[200],
                          ),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                              
                              },
                              child: Text('Add'),
                            ),
                          ),

                        ),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Container(
                          margin: EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.grey[200],
                          ),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                              
                              },
                              child: Text('Add'),
                            ),
                          ),

                        ),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Container(
                          margin: EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                              
                              },
                              child: Text('Add'),
                            ),
                          ),

                        ),
                      ),

                    ],
                  ),

                ),  
                SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    // Add  next button action here
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

            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 25, bottom: 5),
                  child: 
                    Text(
                      '5/5',
                      style: TextStyle(color: Colors.purple, fontSize: 16),
                    ),
                ),
                

                Padding(
                  padding: EdgeInsets.only(left: 15, right: 10, bottom: 20.0),
                  
                  child: new LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 30,
                    animation: false,
                    lineHeight: 10.0,
                    // animationDuration: 2500,
                    percent: 1,
                    barRadius: Radius.circular(10.0),
                    progressColor: Color.fromRGBO(221, 136, 207, 1),
                  ),
                ),
                
              ],
            )

            
          ],
        )
      )

    );
  }
}


class CircularContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      margin: EdgeInsets.only(top:30, bottom: 20),
      
      decoration: BoxDecoration(
        color: Colors.purple.shade200,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.purple.shade100.withOpacity(0.8),
            spreadRadius: 15,
            blurRadius: 15,
            offset: Offset(0, 5), // changes position of shadow
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

