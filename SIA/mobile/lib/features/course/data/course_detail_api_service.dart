import 'dart:convert';
import 'package:http/http.dart' as http;

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
    );
  }
}

class CourseDetailApiService {
  // وب / دسکتاپ: localhost  |  امولاتور اندروید: 10.0.2.2
  static const String baseUrl = 'http://localhost:8080/api/course-details';

  Future<CourseDetail> getDetail(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/$id'))
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