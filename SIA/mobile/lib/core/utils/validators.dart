
import 'persian_digits.dart';

class Validators {
  Validators._();

  static const studentNumberMin = 6;
  static const studentNumberMax = 12;

  static String? required(String? value, String label) =>
      (value == null || value.trim().isEmpty)
          ? '$label را وارد کنید.'
          : null;

  static String? studentNumber(String? value) {
    final empty = required(value, 'شماره دانشجویی');
    if (empty != null) return empty;

    final digits = toEnglishDigits(value!.trim());

    if (!RegExp(r'^\d+$').hasMatch(digits)) {
      return 'شماره دانشجویی فقط باید عدد باشد.';
    }

    if (digits.length < studentNumberMin ||
        digits.length > studentNumberMax) {
      return 'شماره دانشجویی باید بین ${toPersianDigits(studentNumberMin)} تا '
          '${toPersianDigits(studentNumberMax)} رقم باشد.';
    }

    return null;
  }

  /// بررسی رمز عبور هنگام ورود
  static String? password(String? value, {bool checkLength = false}) {
    final empty = required(value, 'رمز عبور');
    if (empty != null) return empty;

    return null;
  }
}
