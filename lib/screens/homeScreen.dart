import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yiddishconnect/utils/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0; // Index of the child currently visible
  // All children
  List<Widget> _pages = [
    HomePage(),
    TestWidgetOne(),
    TestWidgetTwo(),
    TestWidgetThree(),
    TestWidgetFour(),
  ];


  @override
  Widget build(BuildContext context) {
    // Action icons for the current child
    List<Widget> actions = [
      Container(
        // color: Colors.red,
        padding: const EdgeInsets.only(right: 20),
        child: IconButton(
          onPressed: () => toast(context, "TODO: notification"),
          icon: Icon(Icons.notifications),
          iconSize: 24.0
        ),
      ),
    ];

    Widget leading = Padding(
      padding: const EdgeInsets.only(left: 20),
      child: InkWell(
        onTap: () => toast(context, "TODO: user profile?"),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: CircleAvatar(
            backgroundImage: NetworkImage("https://picsum.photos/250"),
            radius: 50
          ),
        ),
      ),
    );


    return Scaffold(
      appBar: AppBar(
        actions: actions,
        leading: leading,
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
          height: 64,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
          margin: EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            // color: Colors.yellow,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
            ],
          ),

          child: SizedBox(
            height: 64,
            child: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.one_k),
                  label: "One",
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.two_k),
                  label: "Two",
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.three_k),
                  label: "Three",
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.four_k),
                  label: "Four",
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
              ],
              currentIndex: _index,
              onTap: (int selectedIndex) {
                setState(() {
                  _index = selectedIndex;
                });
              },
              // backgroundColor: Theme.of(context).colorScheme.surface,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(context).colorScheme.secondary,
              elevation: 0,
              type: BottomNavigationBarType.shifting, // default

            ),
          ),
        ),
      ),
    );
  }
}



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orangeAccent,
      child: Center(
        child: Text('Homeeeee'),
      ),
    );
  }
}

class TestWidgetOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    return Container(
      color: Colors.brown,
      child: Center(
        child: Text('Widget Four'),
      ),
    );
  }
}

