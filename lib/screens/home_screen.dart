import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onlineshop/services/api_service.dart';  // برای استفاده از ApiService

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? accessToken;
  String userName = "Guest User";
  String userProfileImage = 'https://dummyjson.com/icon/emilys/128';
  String userEmail = '';
  Map<String, dynamic>? userResponse;

  @override
  void initState() {
    super.initState();
    _loadToken();  // بارگذاری توکن از SharedPreferences
  }

  // بارگذاری توکن از SharedPreferences
  _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString('access_token');
    });

    // فقط اگر توکن وجود داشت، اطلاعات کاربر رو دریافت کن
    if (accessToken != null) {
      _getUserInfo();
    } else {
      // اگر توکن نبود، userResponse رو به یک Map خالی یا مقدار پیش‌فرض تنظیم کن
      // این کار باعث میشه CircularProgressIndicator دیگه نشون داده نشه
      setState(() {
        userResponse = {}; // یا هر مقدار پیش‌فرض دیگری
      });
    }
  }

  // دریافت اطلاعات کاربر از API
  _getUserInfo() async {
    if (accessToken != null) {
      var user = await ApiService().getCurrentUser();
      if (user != null) {
        setState(() {
          userName = user['firstName'] + ' ' + user['lastName'];
          userProfileImage = user['image'];
          userEmail = user['email'];
          userResponse = user;
        });
      }
    }
  }

  // تابع برای لاگ اوت
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');  // پاک کردن توکن از SharedPreferences
    Navigator.pushReplacementNamed(context, '/login');  // هدایت به صفحه ورود
  }

  // تابع برای ویرایش اطلاعات کاربر (قرار دادن جای خالی برای بعداً)
  void _editUserInfo() {
    // اینجا می‌توانید کد برای ویرایش اطلاعات کاربر اضافه کنید
  }

  // تابع برای ویرایش اطلاعات کاربر (قرار دادن جای خالی برای بعداً)
  void _openCart() {
    // اینجا می‌توانید کد برای ویرایش اطلاعات کاربر اضافه کنید
  }

  void _openCategories(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: _openCart,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(userEmail),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(userProfileImage),
              ),
            ),
            ListTile(
              title: Text('Shopping Cart'),
              onTap: _openCart,
            ),

            ListTile(
              title: Text('Categories'),
              onTap: _openCategories,
            ),

            ListTile(
              title: Text('Edit Profile'),
              onTap: _editUserInfo,
            ),


            ListTile(
              title: Text(accessToken != null ? 'Logout' : 'Login'),
              onTap: () {
                if (accessToken != null) {
                  _logout();
                } else {
                  Navigator.pushReplacementNamed(context, '/login');  // دکمه لاگین برای مهمان
                }
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: userResponse == null
            ? CircularProgressIndicator()  // اگر ریسپانس دریافت نشده باشد
            : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to the Home Page!'),
            ],
          ),
        ),
      ),
    );
  }
}
