import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';  // استفاده از SharedPreferences

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? firstName;
  String? lastName;
  String? imageUrl;
  bool isLoading = true;
  String? token;

  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();  // بررسی وضعیت لاگین
  }

  // بررسی وضعیت لاگین
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');  // دریافت توکن از SharedPreferences

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');  // هدایت به صفحه ورود اگر توکن نباشد
    } else {
      _fetchUserData();  // اگر توکن موجود باشد، داده‌های کاربر را بارگذاری می‌کنیم
    }
  }

  // تابع لاگین برای دریافت توکن
  Future<void> _loginUser() async {
    try {
      final response = await dio.post(
        'https://dummyjson.com/user/login',
        data: {
          'username': 'emilys',
          'password': 'emilyspass',
        },
      );

      if (response.statusCode == 200) {
        token = response.data['token'];  // ذخیره کردن توکن
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token!);  // ذخیره توکن در SharedPreferences
        _fetchUserData();
      } else {
        print("Login failed");
      }
    } catch (e) {
      print("Error logging in: $e");
    }
  }

  // تابع برای دریافت اطلاعات کاربر از API
  Future<void> _fetchUserData() async {
    try {
      final response = await dio.get(
        'https://dummyjson.com/user/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',  // ارسال توکن در هدر
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          firstName = response.data['firstName'];
          lastName = response.data['lastName'];
          imageUrl = response.data['imageUrl'];
          isLoading = false;
        });
      } else {
        print("Failed to load user data");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // متد خروج از حساب کاربری
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');  // حذف توکن از SharedPreferences
    Navigator.pushReplacementNamed(context, '/login');  // هدایت به صفحه ورود پس از خروج
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // لودینگ در زمان دریافت اطلاعات
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // عکس کاربر و نام
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(imageUrl ?? 'https://www.example.com/default_image.jpg'),
                ),
                SizedBox(width: 16),
                Text(
                  '$firstName $lastName',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 24),

            // لیست تایل‌ها
            Expanded(
              child: ListView(
                children: [
                  _buildListTile(
                    context,
                    'User Information',
                    Icons.person,
                        () {
                      // اینجا می‌توانید اطلاعات کاربر را ویرایش کنید یا به صفحه دیگر بروید
                    },
                  ),
                  _buildListTile(
                    context,
                    'Shopping Cart',
                    Icons.shopping_cart,
                        () {
                      // اینجا می‌توانید کاربر را به صفحه سبد خرید هدایت کنید
                    },
                  ),
                  _buildListTile(
                    context,
                    'Logout',
                    Icons.exit_to_app,
                        () {
                      _logout();  // فراخوانی متد خروج
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ویجت برای ساخت لیست تایل‌ها
  Widget _buildListTile(BuildContext context, String title, IconData icon, Function onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: () => onTap(),
    );
  }
}
