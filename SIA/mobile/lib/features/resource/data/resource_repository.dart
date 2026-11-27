import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/auth_http_client.dart';
import '../../../core/utils/file_validator.dart';
import '../../course/data/course_model.dart';
import 'resource_model.dart';

/// ارتباط با API جزوه‌ها.
class ResourceRepository {
  ResourceRepository([http.Client? client]) : _client = client ?? authHttp;

  final http.Client _client;

  /// ⚠️ موقت: تا زمان آماده شدن اندپوینت‌های /api/resources در بک‌اند روی true بماند.
  /// پس از پوش شدن بک‌اند ۱ و ۲، فقط این مقدار را false کنید.
  static bool useMockData = true;

  // داده‌های آزمایشی موقت برای تست کامل صفحه و سناریوی ارائه
  static final List<ResourceItem> _mockResources = [
    const ResourceItem(
      id: 1,
      title: 'جزوه کامل فصل ۱ تا ۳ ساختمان داده',
      description: 'خلاصه نکات امتحانی و درخت‌های دودویی با مثال حل‌شده.',
      courseId: 2,
      courseName: 'ساختمان داده‌ها',
      uploaderId: 0, // متعلق به کاربر دمو
      uploaderName: 'سارا احمدی',
      format: 'pdf',
      sizeBytes: 2450000,
      isPublic: true,
    ),
    const ResourceItem(
      id: 2,
      title: 'یادداشت‌های شخصی میان‌ترم الگوریتم',
      description: 'تمرین‌های حل‌شده طراحی الگوریتم (فقط برای خودم).',
      courseId: 3,
      courseName: 'طراحی الگوریتم‌ها',
      uploaderId: 0, // جزوه خصوصی کاربر دمو
      uploaderName: 'سارا احمدی',
      format: 'docx',
      sizeBytes: 580000,
      isPublic: false,
    ),
    const ResourceItem(
      id: 3,
      title: 'نمونه سوالات نهایی سیستم‌های عامل',
      description: 'مجموعه سوالات ۵ ترم گذشته به همراه پاسخ تشریحی.',
      courseId: 5,
      courseName: 'سیستم‌های عامل',
      uploaderId: 99, // متعلق به کاربر دیگر
      uploaderName: 'علی رضایی',
      format: 'zip',
      sizeBytes: 5120000,
      isPublic: true,
    ),
    const ResourceItem(
      id: 4,
      title: 'اسلایدهای نمودار کلاس UML',
      description: 'تصویر تخته کلاس تحلیل و طراحی نرم‌افزار.',
      courseId: 1,
      courseName: 'مهندسی نرم‌افزار ۱',
      uploaderId: 99,
      uploaderName: 'مریم محمدی',
      format: 'png',
      sizeBytes: 920000,
      isPublic: true,
    ),
    const ResourceItem(
      id: 5,
      title: 'جزوه خصوصی کاربر دیگر (تست امنیتی)',
      description: 'این جزوه خصوصی کاربر ۹۹ است و نباید دیده شود.',
      courseId: 1,
      courseName: 'مهندسی نرم‌افزار ۱',
      uploaderId: 99,
      uploaderName: 'کاربر ۹۹',
      format: 'pdf',
      sizeBytes: 300000,
      isPublic: false,
    ),
  ];

  // ⚠️ فرضی؛ بعد از جواب ساناز اسم فیلدها اصلاح شود
  static const _fileField = 'file';
  static const _titleField = 'title';
  static const _descriptionField = 'description';
  static const _courseIdField = 'courseId';
  static const _isPublicField = 'isPublic';

  /// دریافت لیست جزوه‌ها با جست‌وجو و فیلتر درس و نوع فایل
  Future<List<ResourceItem>> fetchResources({
    String? query,
    int? courseId,
    String? fileType,
    int? currentUserId,
  }) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      final q = (query ?? '').trim().toLowerCase();

      return _mockResources.where((r) {
        // شرط حریم خصوصی: فقط عمومی‌ها یا جزوه‌های خود کاربر
        final canSee = r.isPublic || (currentUserId != null && r.uploaderId == currentUserId);
        if (!canSee) return false;

        // فیلتر جست‌وجو روی عنوان و توضیحات
        if (q.isNotEmpty) {
          final inTitle = r.title.toLowerCase().contains(q);
          final inDesc = r.description.toLowerCase().contains(q);
          if (!inTitle && !inDesc) return false;
        }

        // فیلتر بر اساس درس
        if (courseId != null && r.courseId != courseId) return false;

        // فیلتر بر اساس نوع فایل
        if (fileType != null && fileType != 'همه' && r.fileCategory != fileType) {
          return false;
        }

        return true;
      }).toList();
    }

    final params = <String, String>{
      if (query != null && query.trim().isNotEmpty) 'search': query.trim(),
      if (courseId != null) 'courseId': courseId.toString(),
      if (fileType != null && fileType != 'همه') 'type': fileType,
    };

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.resourcesPath}')
        .replace(queryParameters: params.isEmpty ? null : params);

    final http.Response response;
    try {
      response = await _client.get(uri).timeout(ApiConfig.timeout);
    } on TimeoutException {
      throw const ApiException('پاسخی از سرور نرسید. دوباره تلاش کنید.');
    } on http.ClientException {
      throw const ApiException(
        'اتصال به سرور برقرار نشد. مطمئن شوید بک‌اند روشن است.',
      );
    }

    if (response.statusCode != 200) {
      throw ApiException(
        ApiException.defaultMessage(response.statusCode),
        statusCode: response.statusCode,
      );
    }

    final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
    return body
        .map((e) => ResourceItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// حذف جزوه توسط مالک
  Future<void> deleteResource(int resourceId) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 250));
      _mockResources.removeWhere((r) => r.id == resourceId);
      return;
    }

    final uri =
    Uri.parse('${ApiConfig.baseUrl}${ApiConfig.resourcesPath}/$resourceId');

    final http.Response response;
    try {
      response = await _client.delete(uri).timeout(ApiConfig.timeout);
    } on TimeoutException {
      throw const ApiException('پاسخی از سرور نرسید. دوباره تلاش کنید.');
    } on http.ClientException {
      throw const ApiException('اتصال به سرور برقرار نشد.');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) return;

    if (response.statusCode == 403) {
      throw const ApiException(
        'شما فقط اجازه حذف جزوه‌های خودتان را دارید.',
        statusCode: 403,
      );
    }

    throw ApiException(
      ApiException.defaultMessage(response.statusCode),
      statusCode: response.statusCode,
    );
  }

  /// دانلود امن جزوه با ارسال خودکار توکن و بررسی خطای 403
  Future<List<int>> downloadResource(
      ResourceItem resource, {
        int? currentUserId,
      }) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 400));
      if (!resource.isPublic && resource.uploaderId != currentUserId) {
        throw const ApiException(
          'دسترسی غیرمجاز (۴۰۳): این جزوه خصوصی است و متعلق به شما نیست.',
          statusCode: 403,
        );
      }
      return utf8.encode('Sample file content for ${resource.title}');
    }

    final uri = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.resourcesPath}/${resource.id}/download',
    );

    final http.Response response;
    try {
      response = await _client.get(uri).timeout(ApiConfig.uploadTimeout);
    } on TimeoutException {
      throw const ApiException('دانلود فایل بیش از حد طول کشید.');
    } on http.ClientException {
      throw const ApiException('اتصال به سرور برقرار نشد.');
    }

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    if (response.statusCode == 403) {
      throw const ApiException(
        'دسترسی غیرمجاز (۴۰۳): این جزوه خصوصی است و اجازه دانلود آن را ندارید.',
        statusCode: 403,
      );
    }

    if (response.statusCode == 401) {
      throw const ApiException(
        'نشست شما منقضی شده است. دوباره وارد شوید.',
        statusCode: 401,
      );
    }

    throw ApiException(
      ApiException.defaultMessage(response.statusCode),
      statusCode: response.statusCode,
    );
  }

  /// دروسی که کاربر اجازه‌ی آپلود جزوه برایشان دارد (پاس‌شده یا ترم جاری).
  Future<List<Course>> fetchEligibleCourses(int userId) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.eligibleCoursesPath}')
        .replace(queryParameters: {'userId': userId.toString()});

    final http.Response response;
    try {
      response = await _client.get(uri).timeout(ApiConfig.timeout);
    } on TimeoutException {
      throw const ApiException('پاسخی از سرور نرسید. دوباره تلاش کنید.');
    } on http.ClientException {
      throw const ApiException(
        'اتصال به سرور برقرار نشد. مطمئن شوید بک‌اند روشن است.',
      );
    }

    if (response.statusCode != 200) {
      throw ApiException(
        ApiException.defaultMessage(response.statusCode),
        statusCode: response.statusCode,
      );
    }

    final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
    return body.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> upload({
    required String title,
    required String description,
    required int courseId,
    required bool isPublic,
    required PlatformFile file,
  }) async {
    final bytes = file.bytes;
    if (bytes == null) {
      throw const ApiException('خواندن فایل انجام نشد. فایل را دوباره انتخاب کنید.');
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.resourcesPath}'),
    )
      ..fields[_titleField] = title
      ..fields[_descriptionField] = description
      ..fields[_courseIdField] = courseId.toString()
      ..fields[_isPublicField] = isPublic.toString()
      ..files.add(
        http.MultipartFile.fromBytes(
          _fileField,
          bytes,
          filename: file.name,
          contentType: _mediaType(FileValidator.extensionOf(file.name)),
        ),
      );

    final http.Response response;
    try {
      final streamed =
      await _client.send(request).timeout(ApiConfig.uploadTimeout);
      response = await http.Response.fromStream(streamed);
    } on TimeoutException {
      throw const ApiException('آپلود بیش از حد طول کشید. دوباره تلاش کنید.');
    } on http.ClientException {
      throw const ApiException(
        'اتصال به سرور برقرار نشد. مطمئن شوید بک‌اند روشن است.',
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) return;

    throw ApiException(
      _errorMessage(response.statusCode),
      statusCode: response.statusCode,
    );
  }

  String _errorMessage(int code) {
    switch (code) {
      case 400:
        return 'اطلاعات جزوه یا فایل معتبر نیست.';
      case 401:
        return 'نشست شما منقضی شده است. دوباره وارد شوید.';
      case 403:
        return 'اجازه‌ی آپلود جزوه را ندارید.';
      case 413:
        return 'حجم فایل از حد مجاز سرور بیشتر است.';
      default:
        return ApiException.defaultMessage(code);
    }
  }

  MediaType _mediaType(String ext) {
    switch (ext) {
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'docx':
        return MediaType('application',
            'vnd.openxmlformats-officedocument.wordprocessingml.document');
      case 'zip':
        return MediaType('application', 'zip');
      case 'png':
        return MediaType('image', 'png');
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      default:
        return MediaType('application', 'octet-stream');
    }
  }
}