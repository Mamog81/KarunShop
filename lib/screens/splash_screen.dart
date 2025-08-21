import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // چک کردن توکن ذخیره‌شده
  _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');  // دریافت توکن از SharedPreferences

    // اگر توکن موجود باشد، به صفحه خانه هدایت می‌شود
    if (accessToken != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // در غیر این صورت به صفحه ورود هدایت می‌شود
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          'Welcome to the Online Shop!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
