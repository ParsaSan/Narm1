class ApiConfig {
  ApiConfig._();

  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api',
  );

  // مطابق AuthController.java بک‌اند
  static const loginPath = '/auth/login';

  // ⚠️ فرضی؛ بعد از جواب ساناز اصلاح شود
  static const tokenField = 'token';
  static const resourcesPath = '/resources';

  // محدودیت‌های آپلود جزوه
  static const maxFileBytes = 100 * 1024 * 1024; // ۱۰۰ مگابایت
  static const allowedFileExtensions = ['pdf', 'docx', 'zip', 'png', 'jpg', 'jpeg'];

  static const timeout = Duration(seconds: 10);
  static const uploadTimeout = Duration(minutes: 10);
}