import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student_profile_model.dart';

class ProfileApiService {
  // اندروید امولاتور: 10.0.2.2
  // iOS سیمولاتور / وب / دسکتاپ: localhost
  // گوشی واقعی: IP کامپیوتر، مثلا 192.168.1.5
  static const String baseUrl = 'http://localhost:8080/api/profile';

  static const Duration _timeout = Duration(seconds: 10);

  Future<StudentProfile> getProfile() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return StudentProfile.fromJson(data as Map<String, dynamic>);
      }
      throw Exception('خطا در دریافت پروفایل (کد ${response.statusCode})');
    } on Exception catch (e) {
      throw Exception(_cleanMessage(e, 'اتصال به سرور برقرار نشد'));
    }
  }

  Future<StudentProfile> updateProfile(StudentProfile profile) async {
    try {
      final response = await http
          .put(
            Uri.parse(baseUrl),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(profile.toUpdateJson()),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return StudentProfile.fromJson(data as Map<String, dynamic>);
      }
      if (response.statusCode == 400) {
        throw Exception('اطلاعات واردشده معتبر نیست');
      }
      throw Exception('خطا در ذخیره پروفایل (کد ${response.statusCode})');
    } on Exception catch (e) {
      throw Exception(_cleanMessage(e, 'اتصال به سرور برقرار نشد'));
    }
  }

  String _cleanMessage(Object e, String fallback) {
    final text = e.toString().replaceFirst('Exception: ', '');
    // خطاهای شبکه (SocketException, TimeoutException) پیام فنی دارن
    if (text.contains('SocketException') ||
        text.contains('TimeoutException') ||
        text.contains('ClientException')) {
      return fallback;
    }
    return text;
  }
}