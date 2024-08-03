import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    print("User-Screen build()");
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO: UserScreen"),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          _buildAvatarCard(),
          _buildCard1(),
          _buildCard2(),
        ],
      ),
    );
  }

  Widget _buildAvatarCard() {
    return Container(
      height: 200,
      padding: EdgeInsets.all(10),
      color: Colors.red,
      child: CircleAvatar(
        backgroundImage: NetworkImage('https://picsum.photos/200'),
        radius: 50,
      ),
    );
  }

  Widget _buildCard1() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.blue,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCardItem(() { print("clicked"); }, Icons.add, "first one"),
            _buildCardItem(() { print("clicked"); }, Icons.add, "first one"),
            _buildCardItem(() { print("clicked"); }, Icons.add, "first one"),
          ],
        ),
      ),
    );
  }

  Widget _buildCard2() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.green,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCardItem(() { print("clicked"); }, Icons.add, "first one"),
            _buildCardItem(() { print("clicked"); }, Icons.add, "first one"),
            _buildCardItem(() { print("clicked"); }, Icons.add, "first one"),
          ],
        ),
      ),
    );
  }

  Widget _buildCardItem(void Function() onPressed, IconData iconData, String name) {
    return Row(
      children: [
        Expanded(
          child: (
            FilledButton(
              onPressed: onPressed,
              child: Row(
                children: [
                  Icon(iconData),
                  Text(name)
                ],
              ),
            )
          ),
        )
      ],
    );
  }
}
