import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _loginTimeKey = 'login_time';
  static SharedPreferences? _preferences;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    // print('Shared Preferences initialized');
  }

  // Record login time
  static Future<void> logIn() async {
    await _preferences!
        .setInt(_loginTimeKey, DateTime.now().millisecondsSinceEpoch);
    // print('Login time recorded');
  }

  // Calculate session duration and display in dialog
  static Future<void> logOut(BuildContext context) async {
    // Ensure preferences are initialized
    if (_preferences == null) {
      await init();
    }

    final int? loginTimeMillis = _preferences!.getInt(_loginTimeKey);
    // print('Login time: $loginTimeMillis');
    if (loginTimeMillis != null) {
      final DateTime loginTime =
          DateTime.fromMillisecondsSinceEpoch(loginTimeMillis);
      final DateTime logoutTime = DateTime.now();
      final Duration sessionDuration = logoutTime.difference(loginTime);
      final int minutes = sessionDuration.inMinutes;
      final int seconds = sessionDuration.inSeconds % 60;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Session Time'),
            content: Text(
                'Your session lasted for $minutes minutes and $seconds seconds.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      // Clear login time from SharedPreferences
      await _preferences!.remove(_loginTimeKey);
    }
  }
}
