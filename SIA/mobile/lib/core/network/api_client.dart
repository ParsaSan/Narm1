import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// درخواست POST با بدنه‌ی JSON. پاسخ JSON را برمی‌گرداند؛
  /// اگر پاسخ متن ساده باشد (مثل "Registration successful") نقشه‌ی خالی برمی‌گردد.
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse('${ApiConfig.baseUrl}$path'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeout);
    } on TimeoutException {
      throw const ApiException(
        'پاسخی از سرور نرسید. مطمئن شوید بک‌اند روشن است و دوباره تلاش کنید.',
      );
    } on http.ClientException {
      throw const ApiException(
        'اتصال به سرور برقرار نشد. مطمئن شوید بک‌اند روشن است.',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        ApiException.defaultMessage(response.statusCode),
        statusCode: response.statusCode,
      );
    }
    return _decode(response);
  }

  /// بدنه همیشه با UTF-8 خوانده می‌شود تا متن فارسی خراب نشود.
  Map<String, dynamic> _decode(http.Response response) {
    if (response.bodyBytes.isEmpty) return {};
    try {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data is Map<String, dynamic> ? data : {};
    } on FormatException {
      return {};
    }
  }
}
