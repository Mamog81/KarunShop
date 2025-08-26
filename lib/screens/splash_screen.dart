import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

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

  _checkLoginStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Ensure that the authentication status is checked
    await authProvider.checkAuthStatus();

    // Introducing a delay for smooth transition to home/login screen
    Future.delayed(const Duration(seconds: 2), () {
      if (authProvider.isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.nBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Adding the logo (Icon) with a fade-in effect
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(seconds: 2), // Fade effect duration
              child: Icon(
                Icons.water, // Logo icon
                size: 100,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            // Welcome message with fade effect
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(seconds: 2), // Fade effect duration
              child: Text(
                'Karun Shop',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
