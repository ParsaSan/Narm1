// مدل خلاصه درس برای نمایش در کارت‌های فهرست دروس (تسک آرمیتا)
class CourseSummary {
  final int id;
  final String title;
  final String instructorName;
  final int price;
  final double rating;
  final String thumbnailUrl;
  final String category;

  CourseSummary({
    required this.id,
    required this.title,
    required this.instructorName,
    required this.price,
    required this.rating,
    required this.thumbnailUrl,
    required this.category,
  });

  factory CourseSummary.fromJson(Map<String, dynamic> json) {
    return CourseSummary(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      instructorName: json['instructorName'] ?? json['instructor'] ?? '',
      price: json['price'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      thumbnailUrl: json['thumbnailUrl'] ?? json['image'] ?? '',
      category: json['category'] ?? 'عمومی',
    );
  }
}

// مدل کامل جزئیات درس و سرفصل‌ها برای صفحه اختصاصی (تسک پارسا)
class CourseDetail {
  final int id;
  final String title;
  final String subtitle;
  final String description;
  final String thumbnailUrl;
  final String duration;
  final String level;
  final double rating;
  final int studentsCount;
  final int price;
  final int discountPrice;
  final CourseInstructor instructor;
  final List<CourseChapter> chapters;

  CourseDetail({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.thumbnailUrl,
    required this.duration,
    required this.level,
    required this.rating,
    required this.studentsCount,
    required this.price,
    required this.discountPrice,
    required this.instructor,
    required this.chapters,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      duration: json['duration'] ?? '',
      level: json['level'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      studentsCount: json['studentsCount'] ?? 0,
      price: json['price'] ?? 0,
      discountPrice: json['discountPrice'] ?? 0,
      instructor: CourseInstructor.fromJson(json['instructor'] ?? {}),
      chapters: (json['chapters'] as List<dynamic>? ?? [])
          .map((c) => CourseChapter.fromJson(c))
          .toList(),
    );
  }
}

class CourseInstructor {
  final int id;
  final String name;
  final String role;
  final String avatarUrl;
  final String bio;

  CourseInstructor({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.bio,
  });

  factory CourseInstructor.fromJson(Map<String, dynamic> json) {
    return CourseInstructor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      bio: json['bio'] ?? '',
    );
  }
}

class CourseChapter {
  final int id;
  final String title;
  final List<CourseLesson> lessons;

  CourseChapter({
    required this.id,
    required this.title,
    required this.lessons,
  });

  factory CourseChapter.fromJson(Map<String, dynamic> json) {
    return CourseChapter(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      lessons: (json['lessons'] as List<dynamic>? ?? [])
          .map((l) => CourseLesson.fromJson(l))
          .toList(),
    );
  }
}

class CourseLesson {
  final int id;
  final String title;
  final String duration;
  final bool isFree;

  CourseLesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.isFree,
  });

  factory CourseLesson.fromJson(Map<String, dynamic> json) {
    return CourseLesson(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      isFree: json['isFree'] ?? false,
    );
  }
}