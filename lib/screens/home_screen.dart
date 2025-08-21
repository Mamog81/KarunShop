import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  // تابع برای لاگ اوت
  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');  // پاک کردن توکن از SharedPreferences
    Navigator.pushReplacementNamed(context, '/login');  // هدایت به صفحه ورود
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Home Page!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),  // دکمه لاگ اوت
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
