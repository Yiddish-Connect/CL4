import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../services/auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/percent_indicator.dart';

class addPhoto extends StatelessWidget {
  const addPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leadingWidth: 80,
        leading: Container(
          height: 10.0, 
          width: 10.0,  
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
                              onPressed: () {
                              
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
                  },
                  child: Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(75, 22, 26, 0.6),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 150, vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
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

      //
      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     children: [
      //       Text(
      //         'Upload your photos',
      //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      //       ),
      //       SizedBox(height: 16),
      //       Expanded(
      //         child: GridView.builder(
      //           itemCount: 6,
      //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //             crossAxisCount: 3,
      //             crossAxisSpacing: 10,
      //             mainAxisSpacing: 10,
      //           ),
      //           itemBuilder: (context, index) {
      //             return index == 0
      //                 ? Stack(
      //                     children: [
      //                       Container(
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(8),
      //                           image: DecorationImage(
      //                             image: AssetImage('assets/sample_photo.jpg'), // Your image asset here
      //                             fit: BoxFit.cover,
      //                           ),
      //                         ),
      //                       ),
      //                       Positioned(
      //                         bottom: 8,
      //                         left: 8,
      //                         child: ElevatedButton(
      //                           style: ElevatedButton.styleFrom(
      //                             backgroundColor: Colors.white.withOpacity(0.7),
      //                             shape: RoundedRectangleBorder(
      //                               borderRadius: BorderRadius.circular(8),
      //                             ),
      //                           ),
      //                           onPressed: () {
      //                             // Add your change photo action here
      //                           },
      //                           child: Text(
      //                             'Change Photo',
      //                             style: TextStyle(color: Colors.black),
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   )
      //                 : Container(
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(8),
      //                       color: Colors.grey[300],
      //                     ),
      //                     child: Center(
      //                       child: IconButton(
      //                         icon: Icon(Icons.add),
      //                         onPressed: () {
      //                           // Add your add photo action here
      //                         },
      //                       ),
      //                     ),
      //                   );
      //           },
      //         ),
      //       ),
      //       // SizedBox(height: 16),
      //       ElevatedButton(
      //         onPressed: () {
      //           // Add  next button action here
      //         },
      //         child: Text('Next'),
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: Colors.purple,
      //           foregroundColor: Colors.white,
      //           padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      //           textStyle: TextStyle(fontSize: 18),
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(30),
      //           ),
      //         ),
      //       ),
      //       SizedBox(height: 16),
      //       Text(
      //         '5/5',
      //         style: TextStyle(color: Colors.purple, fontSize: 16),
      //       ),
      //     ],
      //   ),
      // ),


class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: backgroundColor,
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}
