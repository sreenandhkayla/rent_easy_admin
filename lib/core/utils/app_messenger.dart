import 'package:flutter/material.dart';

extension AppMessenger on BuildContext {
  void showAppMessage(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
