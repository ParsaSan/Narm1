import 'package:shared_preferences/shared_preferences.dart';

/// ذخیره‌ی session روی گوشی (روی وب خودش localStorage می‌شود).
class AuthStorage {
  AuthStorage._();

  static const _kToken = 'auth_token';
  static const _kUserId = 'auth_user_id';
  static const _kFirstName = 'auth_first_name';
  static const _kLastName = 'auth_last_name';
  static const _kStudentNumber = 'auth_student_number';

  static Future<void> save({
    required String token,
    int? userId,
    required String firstName,
    required String lastName,
    required String studentNumber,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kToken, token);
    if (userId != null) await p.setInt(_kUserId, userId);
    await p.setString(_kFirstName, firstName);
    await p.setString(_kLastName, lastName);
    await p.setString(_kStudentNumber, studentNumber);
  }

  static Future<String?> getToken() async =>
      (await SharedPreferences.getInstance()).getString(_kToken);

  /// null یعنی session ذخیره‌شده‌ای نیست.
  static Future<Map<String, dynamic>?> loadUser() async {
    final p = await SharedPreferences.getInstance();
    final token = p.getString(_kToken);
    if (token == null || token.isEmpty) return null;
    return {
      'id': p.getInt(_kUserId),
      'firstName': p.getString(_kFirstName) ?? '',
      'lastName': p.getString(_kLastName) ?? '',
      'studentNumber': p.getString(_kStudentNumber) ?? '',
    };
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    for (final k in [_kToken, _kUserId, _kFirstName, _kLastName, _kStudentNumber]) {
      await p.remove(k);
    }
  }
}