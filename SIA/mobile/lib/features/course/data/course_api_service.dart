import 'dart:convert';
import 'package:http/http.dart' as http;
import 'course_model.dart';

class CourseApiService {
  // آدرس سرور اسپرینگ بوت (برای مرورگر کروم و وب localhost کار می‌کند)
  static const String baseUrl = 'http://localhost:8080/api/courses';

  // دریافت لیست تمام دروس از سرور
  static Future<List<Course>> fetchCourses({String? type, String? search}) async {
    try {
      final uri = Uri.parse(baseUrl).replace(queryParameters: {
        if (type != null && type != 'همه') 'type': type,
        if (search != null && search.isNotEmpty) 'search': search,
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        return body.map((item) => Course.fromJson(item)).toList();
      } else {
        throw Exception('خطا در دریافت اطلاعات: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطای اتصال به سرور: $e');
    }
  }
}