/// مدل جزوه مطابق نیازهای اسپرینت ۲
class ResourceItem {
  const ResourceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.courseName,
    required this.uploaderId,
    required this.uploaderName,
    required this.format,
    required this.sizeBytes,
    required this.isPublic,
  });

  final int id;
  final String title;
  final String description;
  final int courseId;
  final String courseName;
  final int uploaderId;
  final String uploaderName;
  final String format; // pdf, docx, zip, png, jpg
  final int sizeBytes;
  final bool isPublic;

  /// تبدیل حجم فایل از بایت به متن خوانا (مثلاً KB یا MB)
  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(0)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// دسته‌بندی نوع فایل برای فیلتر
  String get fileCategory {
    final ext = format.toLowerCase();
    if (ext == 'pdf') return 'PDF';
    if (ext == 'docx' || ext == 'doc') return 'DOCX';
    if (ext == 'zip' || ext == 'rar') return 'ZIP';
    if (ext == 'png' || ext == 'jpg' || ext == 'jpeg') return 'تصویر';
    return ext.toUpperCase();
  }

  factory ResourceItem.fromJson(Map<String, dynamic> json) {
    return ResourceItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      courseId: (json['courseId'] as num?)?.toInt() ?? 0,
      courseName: (json['courseName'] ?? json['courseTitle'] ?? 'درس نامشخص')
          .toString(),
      uploaderId: (json['uploaderId'] as num?)?.toInt() ?? 0,
      uploaderName: (json['uploaderName'] ?? json['uploader'] ?? 'کاربر')
          .toString(),
      format: (json['format'] ?? json['fileFormat'] ?? 'pdf')
          .toString()
          .toLowerCase(),
      sizeBytes: (json['sizeBytes'] ?? json['fileSize'] ?? json['size'] ?? 0)
      is num
          ? ((json['sizeBytes'] ?? json['fileSize'] ?? json['size']) as num)
          .toInt()
          : 0,
      isPublic: json['isPublic'] == true,
    );
  }
}