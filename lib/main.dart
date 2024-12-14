import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yiddishconnect/geo.dart';
import 'package:yiddishconnect/models/notification_controller.dart';
import 'package:yiddishconnect/router.dart';
import 'package:yiddishconnect/utils/web_notification.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:universal_html/js.dart';

import 'package:yiddishconnect/ui/notification/notificationProvider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //FirebaseMessaging.instance.getToken().then((onValue) => {
  //print("token $onValue")
  //}); // The then statement prints the FCM token to the console

  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: "Basic",
      channelKey: "Basic Channel",
      channelName: "Basic Notifications",
      channelDescription: "Basic Notifications",
    )
  ], channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: "Basic",
      channelGroupName: "Basic Notifications",
    )
  ]);

  if (!kIsWeb) {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  geoLocation();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  OverlayEntry? entry;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    listenToMessages();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionMethod,
    );
  }

  void listenToMessages() {
    print("Fired..");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //get awsome notifications to listen when firebase recives a message
      print('Received a message: ${message.notification?.title}');

      AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: 1,
        //this must be initialized befor app run
        channelKey: "Basic Channel",
        title: message.notification?.title,
        body: "HI SHatoria",
      ));

      if (kIsWeb) {
        print("web");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => MyAppState()),
      ],
      child: MaterialApp.router(
        title: 'Yiddish Connect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xfff3dbab)),
          textTheme: TextTheme(
            displayLarge: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                fontSize: 57.0),
            displayMedium: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                fontSize: 45.0),
            displaySmall: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 36.0),
            headlineLarge: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 32.0),
            headlineMedium: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 28.0),
            headlineSmall: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 24.0),
            titleLarge: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 22.0),
            titleMedium: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 16.0),
            titleSmall: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
                fontSize: 14.0),
            bodyLarge: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 16.0),
            bodyMedium: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
                fontSize: 14.0),
            bodySmall: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w200,
                fontSize: 12.0),
            labelLarge: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 14.0),
            labelMedium: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 12.0),
            labelSmall: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 11.0),
          ),
        ),
        routerConfig: ydRouter,
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random(); // a random word
}
