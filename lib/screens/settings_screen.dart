import 'package:flutter/material.dart';
import '../utils/shared_preferences_helper.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  void _logout(BuildContext context) async {
    await SharedPreferencesHelper.clearUser(); // Clear user data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Redirect to Login screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _logout(context),
          child: Text('Logout'),
        ),
      ),
    );
  }
}
