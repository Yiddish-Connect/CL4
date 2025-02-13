import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yiddishconnect/ui/auth/dev_signin_signup/dev_home.dart';
import 'package:yiddishconnect/ui/home/event/eventPage.dart';
import 'package:yiddishconnect/ui/home/match/bottomFilter.dart';
import 'package:yiddishconnect/ui/home/match/matchPage.dart';
import 'package:yiddishconnect/ui/home/match/matchPageProvider.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import 'chat/chat_homepage.dart';
import 'friend/friend.dart';
import 'package:yiddishconnect/ui/notification/notificationPage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:yiddishconnect/ui/notification/notificationProvider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:yiddishconnect/services/firestoreService.dart';

/// The home-screen.
/// It contains 5 tabs: home, events, match, friends, chat
/// Route: '/home'

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _drawerIndex = 0;
  int _index = 0;
  List<Widget> _pages = [
    Placeholder(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
  ];
  HashSet<int> _loaded = HashSet();
  bool _soundPlayed = false;
  int _previousNotificationCount = 0;
  FirestoreService _firestoreService = FirestoreService();
  @override
  void initState() {
    _loaded.add(0);
    _pages[0] = HomePage();
    super.initState();
    //get token
    FirebaseMessaging.instance.getToken().then((String? onValue) {
      if (onValue != null) {
        print("token $onValue");
        _firestoreService.addToken(onValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Home-Screen build()...");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MatchPageProvider()),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              actions: _createActions(context, _index),
              leading: _createLeading(context, _index),
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
                margin:
                    EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                  ],
                  color: Theme.of(context).colorScheme.surface,
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
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.explore_outlined),
                          label: "Explore",
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.add),
                          label: "Match",
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.people_outline),
                          label: "Friends",
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.chat_bubble_outline),
                          label: "Chat",
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ),
                      ],
                      currentIndex: _index,
                      onTap: (int selectedIndex) {
                        setState(() {
                          if (_loaded.contains(selectedIndex)) {
                            _index = selectedIndex;
                          } else {
                            _index = selectedIndex;
                            _loaded.add(_index);
                            _pages[_index] = switch (_index) {
                              0 => HomePage(),
                              1 => EventPage(),
                              2 => MatchPage(),
                              3 => FriendPage(),
                              4 => ChatHomepage(),
                              _ => Placeholder(),
                            };
                          }
                        });
                      },
                      selectedItemColor: Theme.of(context).colorScheme.primary,
                      unselectedItemColor:
                          Theme.of(context).colorScheme.secondary,
                      elevation: 0,
                      type: BottomNavigationBarType.shifting, // default
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _createActions(BuildContext context, int index) {
    List<Widget> matchPageActions = [
      Padding(
        padding: const EdgeInsets.all(8),
        child: IconButton(
          onPressed: () => toast(context, "TODO: search"),
          icon: Icon(Icons.search, size: 28.0),
          iconSize: 28.0,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          onPressed: () => showFilter(context),
          icon: Icon(Icons.filter_list, size: 28.0),
          iconSize: 28.0,
        ),
      ),
    ];

    Future<void> _playNotificationSound() async {
      AudioCache.instance = AudioCache(prefix: '');
      final audioPlayer = AudioPlayer();
      await audioPlayer.play(AssetSource('notification_sound.mp3'));
    }

    List<Widget> otherPageActions = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<NotificationProvider>(
          builder: (context, notificationProvider, child) {
            int currentNotificationCount =
                notificationProvider.notifications.length;
            if (currentNotificationCount > _previousNotificationCount) {
              _soundPlayed = false;
            }
            _previousNotificationCount = currentNotificationCount;

            if (currentNotificationCount > 0 && !_soundPlayed) {
              _playNotificationSound();
              _soundPlayed = true;
            }

            return IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              },
              icon: Icon(
                currentNotificationCount > 0
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_outlined,
                size: 28.0,
              ),
              color: currentNotificationCount > 0 ? Colors.red : null,
              iconSize: 28.0,
            );
          },
        ),
      ),
    ];

    return (index == 0 || index == 1 || index == 3 || index == 4)
        ? otherPageActions
        : matchPageActions;
  }

  Widget _createLeading(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: InkWell(
        onTap: () => context.push(
          "/user",
          extra: {'profileImage': "https://picsum.photos/250"},
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: CircleAvatar(
            backgroundImage: NetworkImage("https://picsum.photos/250"),
            radius: 50,
          ),
        ),
      ),
    );
  }
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
