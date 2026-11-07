const _fa = '۰۱۲۳۴۵۶۷۸۹';
const _ar = '٠١٢٣٤٥٦٧٨٩';

/// ارقام فارسی و عربی را به انگلیسی تبدیل می‌کند
/// (کاربر با کیبورد فارسی شناسه را تایپ می‌کند، بک‌اند انگلیسی می‌خواهد).
String toEnglishDigits(String input) {
  final out = StringBuffer();
  for (final ch in input.split('')) {
    final fa = _fa.indexOf(ch);
    final ar = _ar.indexOf(ch);
    out.write(fa >= 0 ? fa : (ar >= 0 ? ar : ch));
  }
  return out.toString();
}

/// برای نمایش اعداد در UI (مثلاً معدل یا تعداد واحد در داشبورد).
String toPersianDigits(Object input) {
  final out = StringBuffer();
  for (final ch in input.toString().split('')) {
    final i = '0123456789'.indexOf(ch);
    out.write(i >= 0 ? _fa[i] : ch);
  }
  return out.toString();
}
