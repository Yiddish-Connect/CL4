import 'package:flutter/material.dart';

void phoneSMSError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content:
        Text("Sorry The Code you have entered is invalid! Please try again!"),
  ));
}

void emailError(BuildContext context, String message) {
  String emailMessage(contextString) {
    switch (contextString) {
      case "invalid-email":
        return "Sorry! The email you have entered is not an email";
      case "invalid-credential":
        return "Sorry! Your email or password is inccorect!";
      default:
        return "Sorry! Your email or password is inccorect!";
    }
  }

  final String errorString = emailMessage(message);

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(errorString),
  ));
}

void googleError(BuildContext context, String message) {
  String emailMessage(contextString) {
    switch (contextString) {
      case "cancelled-popup-request":
        return "Sorry! The operation was cancelled!";
      case "popup-closed-by-user":
        return "Sorry, you closed the popup! Due to this you can't login!";
      default:
        return "Sorry! We were unable to authenticate you!";
    }
  }

  final String errorString = emailMessage(message);

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(errorString),
  ));
}
