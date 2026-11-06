class StudentProfile {
  final int id;
  final String fullName;
  final String studentType;
  final String studentNumber;
  final String major;
  final String universityEmail;
  final int entryYear;
  final double gpa;
  final String educationStatus;
  final String phone;
  final String personalEmail;
  final String bio;
  final List<RegisteredCourse> registeredCourses;

  StudentProfile({
    required this.id,
    required this.fullName,
    required this.studentType,
    required this.studentNumber,
    required this.major,
    required this.universityEmail,
    required this.entryYear,
    required this.gpa,
    required this.educationStatus,
    required this.phone,
    required this.personalEmail,
    required this.bio,
    required this.registeredCourses,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fullName: json['fullName'] ?? '',
      studentType: json['studentType'] ?? '',
      studentNumber: json['studentNumber'] ?? '',
      major: json['major'] ?? '',
      universityEmail: json['universityEmail'] ?? '',
      entryYear: (json['entryYear'] as num?)?.toInt() ?? 0,
      gpa: (json['gpa'] as num?)?.toDouble() ?? 0.0,
      educationStatus: json['educationStatus'] ?? '',
      phone: json['phone'] ?? '',
      personalEmail: json['personalEmail'] ?? '',
      bio: json['bio'] ?? '',
      registeredCourses: (json['enrolledCourses'] as List<dynamic>? ?? [])
          .map((c) => RegisteredCourse.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  /// فقط فیلدهایی که بک‌اند اجازه ویرایششون رو می‌ده
  Map<String, dynamic> toUpdateJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'personalEmail': personalEmail,
      'bio': bio,
    };
  }

  StudentProfile copyWith({
    String? fullName,
    String? phone,
    String? personalEmail,
    String? bio,
  }) {
    return StudentProfile(
      id: id,
      fullName: fullName ?? this.fullName,
      studentType: studentType,
      studentNumber: studentNumber,
      major: major,
      universityEmail: universityEmail,
      entryYear: entryYear,
      gpa: gpa,
      educationStatus: educationStatus,
      phone: phone ?? this.phone,
      personalEmail: personalEmail ?? this.personalEmail,
      bio: bio ?? this.bio,
      registeredCourses: registeredCourses,
    );
  }
}

class RegisteredCourse {
  final int id;
  final String title;
  final String instructor;
  final int units;
  final String status;

  RegisteredCourse({
    required this.id,
    required this.title,
    required this.instructor,
    required this.units,
    required this.status,
  });

  factory RegisteredCourse.fromJson(Map<String, dynamic> json) {
    return RegisteredCourse(
      id: (json['courseId'] as num?)?.toInt() ?? 0,
      title: json['title'] ?? '',
      instructor: json['instructorName'] ?? '',
      units: (json['units'] as num?)?.toInt() ?? 3,
      status: json['membershipStatus'] ?? 'عضو فعال',
    );
  }
}