// مدل آمار تحصیلی دانشجو
class DashboardStatsModel {
  final int currentTerm;
  final int passedUnits;
  final int currentTermUnits;
  final int currentTermCoursesCount;
  final String gpaTrend;
  final List<double> pastTermGpas;

  DashboardStatsModel({
    required this.currentTerm,
    required this.passedUnits,
    required this.currentTermUnits,
    required this.currentTermCoursesCount,
    required this.gpaTrend,
    required this.pastTermGpas,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    var gpasFromJson = json['pastTermGpas'] as List? ?? [];
    List<double> gpasList = gpasFromJson.map((e) => (e as num).toDouble()).toList();

    return DashboardStatsModel(
      currentTerm: json['currentTerm'] ?? 1,
      passedUnits: json['passedUnits'] ?? 0,
      currentTermUnits: json['currentTermUnits'] ?? 0,
      currentTermCoursesCount: json['currentTermCoursesCount'] ?? 0,
      gpaTrend: json['gpaTrend'] ?? 'ثابت',
      pastTermGpas: gpasList,
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