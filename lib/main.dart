import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:yiddishconnect/router.dart';
import 'package:yiddishconnect/ui/home/match/matchPageProvider.dart';
import 'package:yiddishconnect/ui/notification/notificationProvider.dart';
import 'firebase_options.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Setup local notification settings
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _setupPushNotifications();
  }

  void _setupPushNotifications() async {
    // Request permission (only required on iOS & Android 13+)
    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'default_channel',
                'App Notifications',
                channelDescription: 'YiddishConnect Notifications',
                importance: Importance.high,
                priority: Priority.high,
              ),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => MyAppState()),
        ChangeNotifierProvider(create: (context) => MatchPageProvider()),
      ],
      child: MaterialApp.router(
        title: 'Yiddish Connect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xfff3dbab)),
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w900, fontSize: 57.0),
            displayMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w800, fontSize: 45.0),
            displaySmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 36.0),
            headlineLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 32.0),
            headlineMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 28.0),
            headlineSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 24.0),
            titleLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 22.0),
            titleMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 16.0),
            titleSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300, fontSize: 14.0),
            bodyLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 16.0),
            bodyMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300, fontSize: 14.0),
            bodySmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w200, fontSize: 12.0),
            labelLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14.0),
            labelMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 12.0),
            labelSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 11.0),
          ),
        ),
        routerConfig: ydRouter,
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

