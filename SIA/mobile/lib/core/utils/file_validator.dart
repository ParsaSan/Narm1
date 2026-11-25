import '../config/api_config.dart';
import 'persian_digits.dart';

/// اعتبارسنجی سمت کلاینت فایل جزوه (پسوند و حجم).
class FileValidator {
  FileValidator._();

  static String extensionOf(String fileName) {
    final i = fileName.lastIndexOf('.');
    return i < 0 ? '' : fileName.substring(i + 1).toLowerCase();
  }

  /// null یعنی فایل معتبر است.
  static String? validate({String? name, int? size}) {
    if (name == null || size == null) return 'فایل جزوه را انتخاب کنید.';

    final ext = extensionOf(name);
    if (!ApiConfig.allowedFileExtensions.contains(ext)) {
      return 'فرمت فایل مجاز نیست. فرمت‌های مجاز: PDF، DOCX، ZIP، تصویر (PNG, JPG).';
    }
    if (size <= 0) return 'فایل انتخاب‌شده خالی است.';
    if (size > ApiConfig.maxFileBytes) {
      final maxMb = ApiConfig.maxFileBytes ~/ (1024 * 1024);
      return 'حجم فایل بیشتر از ${toPersianDigits(maxMb)} مگابایت است.';
    }
    return null;
  }

  static String formatSize(int bytes) {
    if (bytes < 1024 * 1024) {
      return '${toPersianDigits((bytes / 1024).toStringAsFixed(0))} کیلوبایت';
    }
    return '${toPersianDigits((bytes / (1024 * 1024)).toStringAsFixed(1))} مگابایت';
  }
}