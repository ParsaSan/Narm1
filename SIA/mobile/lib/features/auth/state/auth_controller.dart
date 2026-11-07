import 'package:flutter/foundation.dart';

import '../data/auth_models.dart';
import '../data/auth_repository.dart';

/// نگه‌دارنده‌ی کاربر واردشده. بقیه‌ی صفحه‌ها می‌توانند از
/// authController.user استفاده کنند (مثلاً برای «سلام، سارا»).
///
/// بک‌اند فعلاً توکن نمی‌دهد، پس ورود فقط تا بسته شدن اپ معتبر است.
class AuthController extends ChangeNotifier {
  AuthController([AuthRepository? repository])
      : _repo = repository ?? AuthRepository();

  final AuthRepository _repo;

  AppUser? _user;
  bool _isDemo = false;

  AppUser? get user => _user;
  bool get isDemo => _isDemo;
  bool get isLoggedIn => _user != null;

  Future<void> login({required String identifier, required String password}) async {
    _user = await _repo.login(identifier: identifier, password: password);
    _isDemo = false;
    notifyListeners();
  }

  Future<void> register(RegisterRequest request) => _repo.register(request);

  void loginAsDemo() {
    _user = AppUser.demo;
    _isDemo = true;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isDemo = false;
    notifyListeners();
  }
}

/// نمونه‌ی سراسری که همه‌ی صفحه‌ها از آن استفاده می‌کنند.
final authController = AuthController();
