import 'package:http/http.dart' as http;

import '../../features/auth/data/auth_storage.dart';

/// کلاینت HTTP که روی همه‌ی درخواست‌ها Authorization: Bearer می‌گذارد
/// و اگر سرور 401 داد، session را پاک می‌کند.
class AuthHttpClient extends http.BaseClient {
  AuthHttpClient([http.Client? inner]) : _inner = inner ?? http.Client();

  final http.Client _inner;

  /// صفحه‌ی اصلی اپ این را وصل می‌کند تا موقع 401 به صفحه‌ی ورود برگردد.
  static void Function()? onUnauthorized;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await AuthStorage.getToken();
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await _inner.send(request);

    if (response.statusCode == 401 && token != null && token.isNotEmpty) {
      await AuthStorage.clear();
      onUnauthorized?.call();
    }
    return response;
  }
}

/// نمونه‌ی مشترک
final authHttp = AuthHttpClient();