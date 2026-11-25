import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/auth_http_client.dart';
import '../../../core/utils/file_validator.dart';

/// ارتباط با API جزوه‌ها.
class ResourceRepository {
  ResourceRepository([http.Client? client]) : _client = client ?? authHttp;

  final http.Client _client;

  // ⚠️ فرضی؛ بعد از جواب ساناز اسم فیلدها اصلاح شود
  static const _fileField = 'file';
  static const _titleField = 'title';
  static const _descriptionField = 'description';
  static const _courseIdField = 'courseId';
  static const _isPublicField = 'isPublic';

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