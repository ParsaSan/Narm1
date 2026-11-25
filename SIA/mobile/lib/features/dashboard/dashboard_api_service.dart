import 'dart:convert';
import '../../core/network/auth_http_client.dart';
import 'dashboard_models.dart';

class DashboardApiService {
  // آدرس پایه سرور بک‌اند جاوا
  static const String baseUrl = 'http://localhost:8080/api/dashboard';

  // ۱. دریافت آمار اولیه سامانه
  Future<DashboardStatsModel> fetchStats() async {
    final response = await authHttp.get(Uri.parse('$baseUrl/stats'));
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return DashboardStatsModel.fromJson(data);
    } else {
      throw Exception('خطا در دریافت آمار از سرور');
    }
  }

  // ۲. دریافت بنرها
  Future<List<BannerModel>> fetchBanners() async {
    final response = await authHttp.get(Uri.parse('$baseUrl/banners'));
    if (response.statusCode == 200) {
      final List data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((item) => BannerModel.fromJson(item)).toList();
    } else {
      throw Exception('خطا در دریافت بنرها از سرور');
    }
  }

  // ۳. دریافت ۳ درس اخیراً بازدیدشده
  Future<List<RecentCourseModel>> fetchRecentCourses() async {
    final response = await authHttp.get(Uri.parse('$baseUrl/recent-courses'));
    if (response.statusCode == 200) {
      final List data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((item) => RecentCourseModel.fromJson(item)).toList();
    } else {
      throw Exception('خطا در دریافت دروس اخیر از سرور');
    }
  }

  // ۴. ارسال کلیک و بازدید درس به سرور
  Future<void> recordVisit(int courseId, String title, String instructor) async {
    try {
      await authHttp.post(
        Uri.parse('$baseUrl/recent-courses/visit'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'id': courseId,
          'title': title,
          'instructor': instructor,
        }),
      );
    } catch (_) {}
  }

}