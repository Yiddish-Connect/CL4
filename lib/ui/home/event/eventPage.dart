import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yiddishconnect/models/yiddishlandEvent.dart';
import 'package:yiddishconnect/services/firestore.dart';

class EventPage extends StatefulWidget {
  EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late Future<QuerySnapshot> futureEvents;
  final SearchController searchController = SearchController();


  @override
  void initState() {
    // The events data is only fetched from Firestore once here, when the EventPage widget is first built.
    futureEvents = FirestoreService().yiddishlandEvents.get()
      .then((QuerySnapshot snapshot) {
        print("Successfully fetched ${snapshot.size} yiddishland events!");
        return snapshot;
      })
    ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("eventPage build()");
    return NestedScrollView(
      // Header (a sliver search bar + yiddishland banner)
      headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) => <Widget>[
        // The floating search bar
        SliverAppBar( // https://api.flutter.dev/flutter/material/SliverAppBar-class.html
          pinned: false,
          floating: true,
          snap: true, // Whether show animation when the search bar appears
          automaticallyImplyLeading: false, // If true, this SliverAppBar will automatically inherit the leading from outer AppBar
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            // title: Text("Yiddishland"),
            collapseMode: CollapseMode.parallax, // Which animation to show
            background: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image(image: AssetImage("assets/yiddishland.png"))
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SearchAnchor(
                      searchController: searchController,
                      builder: (BuildContext context, SearchController controller) {
                        return IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            controller.openView();
                          },
                        );
                      },
                      suggestionsBuilder: (BuildContext context, SearchController controller) {
                        return List<ListTile>.generate(4, (int index) {
                          final String item = 'item $index';
                          return ListTile(
                            title: Text(item),
                            onTap: () {
                              setState(() {
                                print("item: $item");
                                controller.closeView(item);
                              });
                            },
                          );
                        });
                      },
                    ),
                  )
                )
              ],
            ),
            // titlePadding: EdgeInsetsDirectional.only(start: 400, bottom: 0), // To position the title
          ),
          backgroundColor: Colors.blueGrey,
        ),
        // A mock widget to show user's selection
        SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
            child: Center(
              child: searchController.text.isEmpty
                  ? const Text('No item selected')
                  : Text('Selected item: ${searchController.value.text}'),
            ),
          ),
        ),
      ],
      // Body (the events)
      body: _createEventList()
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _createEventList() {
    return FutureBuilder(
      future: futureEvents,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
        if (querySnapshot.hasError) {
          print(querySnapshot.error);
          return Text('Something went wrong');
        }

        if (querySnapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        // return ListView(
        //   children: querySnapshot.data!.docs.map((DocumentSnapshot document) {
        //     YiddishlandEvent event = YiddishlandEvent.fromMap(document.data()! as Map<String, dynamic>, document.id);
        //     return _createEventCard(event);
        //   }).toList(),
        // );

        return AnimationLimiter(
          child: ListView.builder(
            itemCount: querySnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot = querySnapshot.data!.docs[index];
              YiddishlandEvent event = YiddishlandEvent.fromMap(documentSnapshot.data()! as Map<String, dynamic>, documentSnapshot.id);

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 2000), // The list will "float" to the screen. The duration is currently 2000ms.
                child: SlideAnimation(
                  verticalOffset: 150.0,
                  child: FadeInAnimation(child: _createEventCard(event)),
                )
              );
            },
          ),
        );
      }
    );
  }

  // Change here to modify the layout of each event card!
  Widget _createEventCard(YiddishlandEvent event) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        leading: event.imageSrc.isNotEmpty
            ? Image.network(
          event.imageSrc,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        )
            : null,
        title: Text(
          event.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text(
              event.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            event.src.isNotEmpty
                ? GestureDetector(
              onTap: () {
                launchUrl(mode: LaunchMode.externalApplication, Uri.parse(event.src)); // url_launcher package
              },
              child: Text(
                event.src,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
