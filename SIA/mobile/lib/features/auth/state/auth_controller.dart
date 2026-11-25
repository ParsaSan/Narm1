
import 'package:flutter/foundation.dart';

import '../data/auth_models.dart';
import '../data/auth_repository.dart';
import '../data/auth_storage.dart';

/// نگه‌دارنده‌ی کاربر واردشده.
/// بقیه‌ی صفحه‌ها می‌توانند از authController.user استفاده کنند.
class AuthController extends ChangeNotifier {
  AuthController([AuthRepository? repository])
      : _repo = repository ?? AuthRepository();

  final AuthRepository _repo;

  AppUser? _user;
  bool _isDemo = false;

  AppUser? get user => _user;
  bool get isDemo => _isDemo;
  bool get isLoggedIn => _user != null;

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    final u = await _repo.login(identifier: identifier, password: password);
    _user = u;
    _isDemo = false;
    await AuthStorage.save(
      token: u.token,
      userId: u.id,
      firstName: u.firstName,
      lastName: u.lastName,
      studentNumber: u.studentNumber,
    );
    notifyListeners();
  }

  /// موقع باز شدن اپ: اگر session ذخیره شده بود، برمی‌گرداند.
  Future<void> restoreSession() async {
    final data = await AuthStorage.loadUser();
    if (data == null) return;
    _user = AppUser.fromJson(data);
    _isDemo = false;
    notifyListeners();
  }

  void loginAsDemo() {
    _user = AppUser.demo;
    _isDemo = true;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isDemo = false;
    AuthStorage.clear();
    notifyListeners();
  }
}

/// نمونه‌ی سراسری که همه‌ی صفحه‌ها از آن استفاده می‌کنند.
final authController = AuthController();
