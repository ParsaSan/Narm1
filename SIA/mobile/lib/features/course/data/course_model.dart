class Course {
  final int id;
  final String code;         // CE-401
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

  // برای وقتی که GET /api/courses آماده شد
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      code: json['code'],
      title: json['title'],
      englishTitle: json['englishTitle'] ?? '',
      description: json['description'] ?? '',
      units: json['units'],
      type: json['type'],
      instructor: json['instructor'],
      isEnrolled: json['enrolled'] ?? false,
    );
  }
}