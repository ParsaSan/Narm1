import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dashboard_models.dart';

class DashboardApiService {
  // آدرس پایه سرور بک‌اند جاوا
  static const String baseUrl = 'http://localhost:8080/api/dashboard';

  // ۱. دریافت آمار اولیه سامانه
  Future<DashboardStatsModel> fetchStats() async {
    final response = await http.get(Uri.parse('$baseUrl/stats'));
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return DashboardStatsModel.fromJson(data);
    } else {
      throw Exception('خطا در دریافت آمار از سرور');
    }
  }

  // ۲. دریافت بنرها
  Future<List<BannerModel>> fetchBanners() async {
    final response = await http.get(Uri.parse('$baseUrl/banners'));
    if (response.statusCode == 200) {
      final List data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((item) => BannerModel.fromJson(item)).toList();
    } else {
      throw Exception('خطا در دریافت بنرها از سرور');
    }
  }

  // ۳. دریافت ۳ درس اخیراً بازدیدشده
  Future<List<RecentCourseModel>> fetchRecentCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/recent-courses'));
    if (response.statusCode == 200) {
      final List data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((item) => RecentCourseModel.fromJson(item)).toList();
    } else {
      throw Exception('خطا در دریافت دروس اخیر از سرور');
    }
  }
}