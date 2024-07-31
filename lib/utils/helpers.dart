// helper functions

import 'package:flutter/material.dart';

/// Shows a toast under the current context
void toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}