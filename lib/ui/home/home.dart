import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';

import 'package:yiddishconnect/ui/home/event/eventPage.dart';
import 'package:yiddishconnect/ui/home/match/matchPage.dart';
import 'package:yiddishconnect/ui/home/match/matchPageProvider.dart';
import 'package:yiddishconnect/ui/home/chat/chat_homepage.dart';
import 'package:yiddishconnect/ui/home/friend/friend.dart';
import 'package:yiddishconnect/ui/notification/notificationPage.dart';
import 'package:yiddishconnect/ui/notification/notificationProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final List<Widget> _pages;
  late final VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    _pages = [
      const HomePage(),
      EventPage(),
      const MatchPage(),
      const FriendsPage(),
      ChatHomepage(),
    ];

    _videoController = VideoPlayerController.asset(
      'assets/videos/200203Abparticle001.mp4',
    )
      ..initialize().then((_) {
        _videoController
          ..setLooping(true)
          ..setVolume(0)
          ..play();
        setState(() {});
      });
  }


  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
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
            Padding(
              padding: const EdgeInsets.all(12),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('profiles')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  final data = snapshot.data?.data() as Map<String, dynamic>?;

                  if (data == null || data['imageUrls'] == null) {
                    return const CircleAvatar(child: Icon(Icons.person));
                  }

                  final imageUrls = data['imageUrls'];
                  if (imageUrls is! List || imageUrls.isEmpty) {
                    return const CircleAvatar(child: Icon(Icons.person));
                  }

                  final firebasePath = imageUrls[0];
                  return FutureBuilder<String>(
                    future: FirebaseStorage.instance
                        .ref(firebasePath)
                        .getDownloadURL(),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return const CircleAvatar(child: Icon(Icons.person));
                      }

                      return GestureDetector(
                        onTap: () => GoRouter.of(context).push('/profile'),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(snap.data!),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: !_videoController.value.isInitialized
            ? const Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
            Container(color: Colors.black.withOpacity(0.3)),
            _pages[_selectedIndex],
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
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
      child: Text(
        'Welcome to Yiddish Connect!',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
