import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider extends ChangeNotifier {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  final List<RemoteMessage> _messages = [];

  List<RemoteMessage> get messages => List.unmodifiable(_messages);
  String? get fcmToken => _fcmToken;

  NotificationProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _requestPermissions();
    await _initLocalNotifications();
    await _setupFCMListeners();
  }

  Future<void> _requestPermissions() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotificationsPlugin.initialize(initSettings);
  }

  Future<void> _setupFCMListeners() async {
    _fcmToken = await _messaging.getToken();
    debugPrint("✅ FCM Token: $_fcmToken");

    // Foreground message
    FirebaseMessaging.onMessage.listen((message) {
      _messages.add(message);
      _showLocalNotification(message);
      notifyListeners();
    });

    // Background tap
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _messages.add(message);
      notifyListeners();
    });

    // App opened from terminated
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _messages.add(initialMessage);
      notifyListeners();
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformDetails,
    );
  }
}

