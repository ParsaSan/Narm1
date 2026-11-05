// مدل آمار اولیه
class DashboardStatsModel {
  final int totalCourses;
  final int totalFiles;
  final int totalStudents;

  DashboardStatsModel({
    required this.totalCourses,
    required this.totalFiles,
    required this.totalStudents,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalCourses: json['totalCourses'] ?? 0,
      totalFiles: json['totalFiles'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
    );
  }
}

// مدل بنر
class BannerModel {
  final int id;
  final String title;
  final String subtitle;
  final String imageUrl;

  BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

// مدل دروس اخیراً بازدیدشده
class RecentCourseModel {
  final int id;
  final String title;
  final String instructor;

  RecentCourseModel({
    required this.id,
    required this.title,
    required this.instructor,
  });

  factory RecentCourseModel.fromJson(Map<String, dynamic> json) {
    return RecentCourseModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      instructor: json['instructor'] ?? '',
    );
  }
}