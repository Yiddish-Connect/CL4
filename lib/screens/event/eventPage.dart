import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final SearchController searchController = SearchController();


  @override
  Widget build(BuildContext context) {
    print("eventPage build()");
    return CustomScrollView(
      slivers: <Widget>[
        // The floating search bar
        SliverAppBar( // https://api.flutter.dev/flutter/material/SliverAppBar-class.html
          pinned: false,
          floating: true,
          snap: true, // Whether show animation when the search bar appears
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            // title: Text("Yiddishland"),
            collapseMode: CollapseMode.parallax, // Which animation to show
            background: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image(image: AssetImage("yiddishland.png"))
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
        // The list of events (With pictures and buttons)
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return ListTile(
                title: Text('Item #$index'),
              );
            },
            childCount: 100, // Number of items in the list
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}
