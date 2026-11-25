import 'dart:convert';
import '../../../core/network/auth_http_client.dart';
import 'course_model.dart';

class CourseApiService {
  static const String _apiBase = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api',
  );
  static String get baseUrl => '$_apiBase/courses';

  static Future<List<Course>> fetchCourses({
    String? type,
    String? search,
    int? userId,
  }) async {
    try {
      final params = <String, String>{
        if (type != null && type != 'همه') 'type': type,
        if (search != null && search.isNotEmpty) 'search': search,
        if (userId != null && userId > 0) 'userId': userId.toString(),
      };
      final uri = params.isEmpty
          ? Uri.parse(baseUrl)
          : Uri.parse(baseUrl).replace(queryParameters: params);

      final response = await authHttp.get(uri);

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