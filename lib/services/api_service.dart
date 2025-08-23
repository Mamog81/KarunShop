import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onlineshop/utils/constants.dart';
class ApiService {


  final Dio _dio = Dio();  // ایجاد شی Dio برای ارسال درخواست‌ها

  // تابع لاگین برای ارسال درخواست POST
  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      // ارسال درخواست به API
      Response response = await _dio.post(
        '${Constants.baseUrl}/auth/login',
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
      String? accessToken = prefs.getString('access_token'); // دریافت توکن از SharedPreferences

      if (accessToken == null) {
        return null; // اگر توکن وجود ندارد، null برمی‌گرداند
      }
      // ارسال درخواست به API برای دریافت اطلاعات کاربر با توکن
      Response response = await _dio.get(
        '${Constants.baseUrl}/auth/me',
        options: Options(
          headers: {'Authorization': '$accessToken'},  // ارسال توکن در هدر
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching current user: $e");
      return null;
    }
  }


  // تابع برای دریافت لیست کتگوری‌ها
  Future<List<String>?> getCategories() async {
    try {
      Response response = await _dio.get(
        '${Constants.baseUrl}/products/category-list',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        // response.data یک List<dynamic> است
        return List<String>.from(response.data);
      } else {
        print("Failed to get categories: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching categories: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAllProducts({int limit = 10, int skip = 0}) async {
    try {
      Response response = await _dio.get(
        '${Constants.baseUrl}/products',
        queryParameters: {
          'limit': limit,
          'skip': skip,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching all products: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> searchProducts(String query) async {
    try {
      Response response = await _dio.get(
        '${Constants.baseUrl}/products/search',
        queryParameters: {
          'q': query,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("Failed to search products: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error searching products: $e");
      return null;
    }
  }


  Future<Map<String, dynamic>?> getProductsByCategory(String category) async {
    try {
      Response response = await _dio.get(
        '${Constants.baseUrl}/products/category/$category',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("Failed to get products for category: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching products by category: $e");
      return null;
    }

  }



}
