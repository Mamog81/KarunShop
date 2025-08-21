import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://dummyjson.com";  // آدرس پایه API

  final Dio _dio = Dio();  // ایجاد شی Dio برای ارسال درخواست‌ها

  // تابع لاگین برای ارسال درخواست POST
  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      // ارسال درخواست به API
      Response response = await _dio.post(
        '$baseUrl/auth/login',
        data: {
          "username": username,
          "password": password,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // بررسی وضعیت پاسخ
      if (response.statusCode == 200) {
        // ذخیره توکن‌ها در SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('access_token', response.data['accessToken']);
        prefs.setString('refresh_token', response.data['refreshToken']);

        // برگشت داده‌های توکن و اطلاعات کاربر
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      // در صورت بروز هرگونه خطا، پیغام خطا را چاپ می‌کند
      print("Error during login: $e");
      return null;
    }
  }

  // تابع برای دریافت اطلاعات کاربر جاری
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token'); // دریافت توکن

      if (accessToken == null) {
        return null; // اگر توکن وجود ندارد، null برمی‌گرداند
      }

      // ارسال درخواست برای دریافت اطلاعات کاربر با توکن
      Response response = await _dio.get(
        '$baseUrl/auth/me',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},  // ارسال توکن در هدر
        ),
      );

      if (response.statusCode == 200) {
        return response.data;  // اطلاعات کاربر جاری را برمی‌گرداند
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching current user: $e");
      return null;
    }
  }

  // تابع برای بروزرسانی session (در صورت استفاده از refresh token)
  Future<Map<String, dynamic>?> refreshSession(String refreshToken) async {
    try {
      Response response = await _dio.post(
        '$baseUrl/auth/refresh',
        data: {
          "refreshToken": refreshToken,  // ارسال refreshToken
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;  // داده‌های توکن جدید را برمی‌گرداند
      } else {
        return null;
      }
    } catch (e) {
      print("Error refreshing session: $e");
      return null;
    }
  }
}
