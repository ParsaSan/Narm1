/// خطایی که پیامش مستقیم به کاربر نشان داده می‌شود.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;

  /// null یعنی اصلاً به سرور نرسیدیم (قطعی اینترنت، خاموش بودن سرور).
  final int? statusCode;

  static String defaultMessage(int code) {
    if (code == 400) return 'اطلاعات واردشده کامل یا معتبر نیست.';
    if (code == 404) return 'این سرویس روی سرور پیدا نشد.';
    if (code >= 500) return 'سرور با خطا مواجه شد. کمی بعد دوباره تلاش کنید.';
    return 'درخواست انجام نشد (کد $code).';
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
