import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import 'auth_models.dart';

/// ارتباط با /api/auth بک‌اند.
///
/// نکته: بک‌اند فعلاً برای «کاربر پیدا نشد»، «رمز اشتباه» و «شماره تکراری»
/// RuntimeException می‌دهد که به‌صورت کد 500 می‌رسد. برای همین این‌جا
/// کد 500 را به پیام مناسب هر عملیات ترجمه می‌کنیم.
class AuthRepository {
  AuthRepository([ApiClient? api]) : _api = api ?? ApiClient();

  final ApiClient _api;

  Future<AppUser> login({required String identifier, required String password}) async {
    try {
      final json = await _api.post(ApiConfig.loginPath, {
        'identifier': identifier,
        'password': password,
      });
      return AppUser.fromJson(json);
    } on ApiException catch (e) {
      final code = e.statusCode;
      if (code == 401 || code == 404 || code == 500) {
        throw ApiException('شماره دانشجویی یا رمز عبور اشتباه است.', statusCode: code);
      }
      rethrow;
    }
  }

  Future<void> register(RegisterRequest request) async {
    try {
      await _api.post(ApiConfig.registerPath, request.toJson());
    } on ApiException catch (e) {
      final code = e.statusCode;
      if (code == 409 || code == 500) {
        throw ApiException(
          'این شماره دانشجویی یا شماره موبایل قبلاً ثبت شده است.',
          statusCode: code,
        );
      }
      rethrow;
    }
  }
}
