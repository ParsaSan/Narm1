/// آدرس سرور بک‌اند (Spring Boot روی پورت 8080).
/// مثل بقیه‌ی سرویس‌های تیم، پیش‌فرض localhost است.
///   - اجرا روی Chrome یا ویندوز: localhost درست است.
///   - امولاتور اندروید: http://10.0.2.2:8080/api
///   - گوشی واقعی: IP کامپیوتر، مثلاً http://192.168.1.5:8080/api
/// بدون تغییر کد هم می‌شود عوضش کرد:
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/api
class ApiConfig {
  ApiConfig._();

  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api',
  );

  // مطابق AuthController.java بک‌اند
  static const loginPath = '/auth/login';
  static const registerPath = '/auth/register';

  static const timeout = Duration(seconds: 10);
}
