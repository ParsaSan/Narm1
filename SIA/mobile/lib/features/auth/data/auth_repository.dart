
import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import 'auth_models.dart';

/// ارتباط با API احراز هویت بک‌اند.
class AuthRepository {
  AuthRepository([ApiClient? api]) : _api = api ?? ApiClient();

  final ApiClient _api;

  Future<AppUser> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final json = await _api.post(ApiConfig.loginPath, {
        'identifier': identifier,
        'password': password,
      });
      return AppUser.fromJson(json);
    } on ApiException catch (e) {
      final code = e.statusCode;
      if (code == 401 || code == 404 || code == 500) {
        throw ApiException(
          'شماره دانشجویی یا رمز عبور اشتباه است.',
          statusCode: code,
        );
      }
      rethrow;
    }
  }
}
