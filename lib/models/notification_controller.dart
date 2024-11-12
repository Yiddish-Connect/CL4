import 'package:awesome_notifications/awesome_notifications.dart';

//at step 5 for android on https://pub.dev/packages/awesome_notifications#-configuring-android-for-awesome-notifications is where it is located
//9:00
class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification recivedNotification) async {
    //what happens when a not is recived goes here if you want
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification recivedNotification) async {
    //what happens when a not is displayed goes here if you want
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionMethod(
      ReceivedNotification recivedNotification) async {
    //what happens when a not is dismissed goes here if you want
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedNotification recivedNotification) async {
    //what happens when a not is clicked goes here if you want
  }
}
