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
    TestWidgetThree()
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
          iconSize: 32,
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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.one_k),
            label: "One",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.two_k),
            label: "Two",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.three_k),
            label: "Three",
          ),
        ],
        currentIndex: _index,
        onTap: (int selectedIndex) {
          setState(() {
            _index = selectedIndex;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.background,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Homeeeee'),
    );
  }
}

class TestWidgetOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Widget One'),
    );
  }
}

class TestWidgetTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: 100,
      height: 100,
    );
  }
}

class TestWidgetThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.star,
      size: 50,
      color: Colors.red,
    );
  }
}

