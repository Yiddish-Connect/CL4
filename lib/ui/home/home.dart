import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yiddishconnect/ui/home/event/eventPage.dart';
import 'package:yiddishconnect/ui/home/match/bottomFilter.dart';
import 'package:yiddishconnect/ui/home/match/matchPage.dart';
import 'package:yiddishconnect/ui/home/match/matchPageProvider.dart';
import 'package:yiddishconnect/ui/home/chat/chat_homepage.dart';
import 'package:yiddishconnect/ui/home/friend/friend.dart';
import 'package:yiddishconnect/ui/notification/notificationPage.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:yiddishconnect/ui/notification/notificationProvider.dart';
import 'package:yiddishconnect/services/firestoreService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      const HomePage(),
      EventPage(),               // ✅ no const
      const MatchPage(),
      const FriendsPage(),
      ChatHomepage(),           // ✅ no const + correct name
    ]);
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MatchPageProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Yiddish Connect'),
          actions: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('profiles')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData || !snapshot.data!.exists) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircleAvatar(child: Icon(Icons.person)),
                  );
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                final imageUrls = data['imageUrls'] as List<dynamic>?;
                final profileImage = (imageUrls != null && imageUrls.isNotEmpty)
                    ? imageUrls[0]
                    : null;

                return GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push('/profile'); // 🔥 Update this to your actual route
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CircleAvatar(
                      backgroundImage: profileImage != null ? NetworkImage(profileImage) : null,
                      child: profileImage == null ? const Icon(Icons.person) : null,
                    ),
                  ),
                );
              },
            ),
          ],
        ),

        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Match'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Welcome to Yiddish Connect!'),
    );
  }
}