import 'persian_digits.dart';

class Validators {
  Validators._();

  static const studentNumberMin = 6;
  static const studentNumberMax = 12;
  static const passwordMin = 8; // مطابق @Size(min = 8) در RegisterRequest.java

  static String? required(String? value, String label) =>
      (value == null || value.trim().isEmpty) ? '$label را وارد کنید.' : null;

  static String? studentNumber(String? value) {
    final empty = required(value, 'شماره دانشجویی');
    if (empty != null) return empty;
    final digits = toEnglishDigits(value!.trim());
    if (!RegExp(r'^\d+$').hasMatch(digits)) {
      return 'شماره دانشجویی فقط باید عدد باشد.';
    }
    if (digits.length < studentNumberMin || digits.length > studentNumberMax) {
      return 'شماره دانشجویی باید بین ${toPersianDigits(studentNumberMin)} تا '
          '${toPersianDigits(studentNumberMax)} رقم باشد.';
    }
    return null;
  }

  /// اختیاری است؛ فقط اگر پر شده باشد بررسی می‌شود.
  static String? optionalPhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final digits = toEnglishDigits(value.trim());
    if (!RegExp(r'^09\d{9}$').hasMatch(digits)) {
      return 'شماره موبایل باید ۱۱ رقم و با ۰۹ شروع شود.';
    }
    return null;
  }

  /// [checkLength] در فرم ورود false است.
  static String? password(String? value, {bool checkLength = true}) {
    final empty = required(value, 'رمز عبور');
    if (empty != null) return empty;
    if (checkLength && value!.length < passwordMin) {
      return 'رمز عبور باید حداقل ${toPersianDigits(passwordMin)} کاراکتر باشد.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    final empty = required(value, 'تکرار رمز عبور');
    if (empty != null) return empty;
    return value == original ? null : 'تکرار رمز عبور با رمز عبور یکسان نیست.';
  }
}
