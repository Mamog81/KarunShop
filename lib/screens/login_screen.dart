import 'package:flutter/material.dart';
import 'package:onlineshop/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    // دریافت اطلاعات لاگین از API
    var result = await _apiService.login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result != null) {
      // در صورتی که ورود موفقیت‌آمیز باشد، به صفحه Home هدایت می‌شود
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // در صورت خطا یا عدم موفقیت در ورود، پیغام خطا نمایش داده می‌شود
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // لینک به صفحه ثبت‌نام
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register'),
            ),
            TextButton(
              onPressed: () {
                // ورود به عنوان مهمان
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('Continue as Guest'),
            ),
          ],
        ),
      ),
    );
  }
}
