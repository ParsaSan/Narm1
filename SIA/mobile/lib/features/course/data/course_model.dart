class Course {
  final int id;
  final String code;         // کد درس مثل 110711306
  final String title;        // عنوان فارسی
  final String englishTitle;
  final String description;
  final int units;
  final String type;         // تخصصی | پایه | عمومی
  final String instructor;
  final bool isEnrolled;

  const Course({
    required this.id,
    required this.code,
    required this.title,
    required this.englishTitle,
    required this.description,
    required this.units,
    required this.type,
    required this.instructor,
    this.isEnrolled = false,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: (json['id'] as num?)?.toInt() ?? 0,
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      englishTitle: json['englishTitle'] ?? '',
      description: json['description'] ?? '',
      units: (json['units'] as num?)?.toInt() ?? 0,
      type: json['type'] ?? 'تخصصی',
      instructor: json['instructor'] ?? '',
      isEnrolled: json['enrolled'] ?? json['isEnrolled'] ?? false,
    );
  }
}