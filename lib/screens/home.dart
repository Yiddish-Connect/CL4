import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yiddishconnect/screens/dev_signin_signup/dev_home.dart';
import 'package:yiddishconnect/screens/match/bottomFilter.dart';
import 'package:yiddishconnect/screens/match/matchPage.dart';
import 'package:yiddishconnect/screens/match/matchPageProvider.dart';
import 'package:yiddishconnect/utils/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Index of the child currently visible
  int _index = 0;
  // All children
  List<Widget> _pages = [
    HomePage(), // _index: 0
    TestWidgetOne(), // _index: 1
    MatchPage(), // _index: 2
    TestWidgetThree(), // _index: 3
    TestWidgetFour(), // _index: 4
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MatchPageProvider())
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              actions: _getActions(context, _index),
              leading: _getLeading(context, _index),
              toolbarHeight: 70,
              leadingWidth: 90,
            ),
            body: IndexedStack(
              index: _index,
              children: _pages,
            ),
            bottomNavigationBar: FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
                margin: EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                    ],
                    color: Theme.of(context).colorScheme.surface
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: SizedBox(
                    height: 60,
                    child: BottomNavigationBar(
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home_outlined),
                          label: "Home",
                          backgroundColor: Theme.of(context).colorScheme.surface,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.explore_outlined),
                          label: "Explore",
                          backgroundColor: Theme.of(context).colorScheme.surface,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.add),
                          label: "Match",
                          backgroundColor: Theme.of(context).colorScheme.surface,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.people_outline),
                          label: "Friends",
                          backgroundColor: Theme.of(context).colorScheme.surface,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.chat_bubble_outline),
                          label: "Chat",
                          backgroundColor: Theme.of(context).colorScheme.surface,
                        ),
                      ],
                      currentIndex: _index,
                      onTap: (int selectedIndex) {
                        setState(() {
                          _index = selectedIndex;
                        });
                      },
                      selectedItemColor: Theme.of(context).colorScheme.primary,
                      unselectedItemColor: Theme.of(context).colorScheme.secondary,
                      elevation: 0,
                      type: BottomNavigationBarType.shifting, // default

                    ),
                  ),
                ),
              ),
            )
          );
        }
      )
    );
  }
}

// Get the "actions" of the Scaffold from given index
List<Widget> _getActions(BuildContext context, int index) {
  List<Widget> matchPageActions = [
    Padding(
      // color: Colors.red,
      padding: const EdgeInsets.all(8),
      child: IconButton(
          onPressed: () => toast(context, "TODO: search"),
          icon: Icon(Icons.search, size: 28.0,),
          iconSize: 28.0
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
          onPressed: () => showFilter(context),
          icon: Icon(Icons.filter_list, size: 28.0),
          iconSize: 28.0
      ),
    ),
  ];

  List<Widget> otherPageActions = [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
          onPressed: () => toast(context, "TODO: notifications"),
          icon: Icon(Icons.notifications_outlined, size: 28.0),
          iconSize: 28.0
      ),
    ),
  ];

  return switch (index) {
    0 || 1 || 3 || 4 => otherPageActions,
    2 => matchPageActions,
    _ => [Container()]
  };
}

// Get the "leading" of the Scaffold from given index
Widget _getLeading(BuildContext context, int index) {
  // The leading will always be the user's profile picture
  return Padding(
      padding: const EdgeInsets.all(0.0),
      child: InkWell(
        onTap: () => toast(context, "TODO: user profile?"),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: CircleAvatar(
              backgroundImage: NetworkImage("https://picsum.photos/250"),
              radius: 50
          ),
        ),
      ))
  ;
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("HomePage build()");

    return Container(
      color: Colors.orangeAccent,
      child: Opacity(
        opacity: 0.5,
        child: Center(
          child: DevHomeScreen(),
        ),
      ),
    );
  }
}

class TestWidgetOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("WidgetOne build()");

    return Container(
      color: Colors.grey,
      child: Center(
        child: Text('Widget One'),
      ),
    );
  }
}

class TestWidgetTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("WidgetTwo build()");

    return Container(
      color: Colors.blueGrey,
      child: Center(
        child: Text('Widget Two'),
      ),
    );
  }
}

class TestWidgetThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("WidgetThree build()");

    return Container(
      color: Colors.teal,
      child: Center(
        child: Text('Widget Three'),
      ),
    );
  }
}

class TestWidgetFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("WidgetFour build()");

    return Container(
      color: Colors.brown,
      child: Center(
        child: Text('Widget Four'),
      ),
    );
  }
}

