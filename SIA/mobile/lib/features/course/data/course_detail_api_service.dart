import 'dart:convert';
import '../../../core/network/auth_http_client.dart';
class CourseDetail {
  final int id;
  final String code;
  final String title;
  final String instructor;
  final int units;
  final String schedule;
  final String location;
  final String about;
  final List<String> chapters;
  final bool enrolled;

  CourseDetail({
    required this.id,
    required this.code,
    required this.title,
    required this.instructor,
    required this.units,
    required this.schedule,
    required this.location,
    required this.about,
    required this.chapters,
    required this.enrolled,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      id: (json['id'] as num?)?.toInt() ?? 0,
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      instructor: json['instructor'] ?? '',
      units: (json['units'] as num?)?.toInt() ?? 0,
      schedule: json['schedule'] ?? '',
      location: json['location'] ?? '',
      about: json['about'] ?? '',
      chapters: (json['chapters'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      enrolled: json['enrolled'] == true,
    );
  }
}

class CourseDetailApiService {
  static const String _apiBase = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api',
  );
  static String get baseUrl => '$_apiBase/course-details';

  Future<CourseDetail> getDetail(int id, {int? userId, String? title}) async {
    try {
      final params = <String, String>{
        if (userId != null && userId > 0) 'userId': userId.toString(),
        if (title != null && title.isNotEmpty) 'title': title,
      };
      final uri = params.isEmpty
          ? Uri.parse('$baseUrl/$id')
          : Uri.parse('$baseUrl/$id').replace(queryParameters: params);

      final response = await authHttp
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return CourseDetail.fromJson(data as Map<String, dynamic>);
      }
      if (response.statusCode == 404) {
        throw Exception('درس پیدا نشد');
      }
      throw Exception('خطا در دریافت اطلاعات درس (کد ${response.statusCode})');
    } on Exception catch (e) {
      final text = e.toString().replaceFirst('Exception: ', '');
      if (text.contains('SocketException') ||
          text.contains('TimeoutException') ||
          text.contains('ClientException')) {
        throw Exception('اتصال به سرور برقرار نشد');
      }
      throw Exception(text);
    }
  }
}