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
    final seccondBracket = contextString.indexOf(']');
    final trimedString = contextString.substring(seccondBracket + 1).trim();

    switch (trimedString) {
      case "The email address is badly formatted.":
        return "Sorry! The email you have intered is not an email";
      case "The supplied auth credential is incorrect, malformed or has expired.":
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
    final seccondBracket = contextString.indexOf(']');
    final trimedString = contextString.substring(seccondBracket + 1).trim();

    switch (trimedString) {
      case "This operation has been cancelled due to another conflicting popup being opened.":
        return "Sorry! The email you have intered is not an email";
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
