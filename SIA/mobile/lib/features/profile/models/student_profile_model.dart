class StudentProfile {
  final String fullName;
  final String studentNumber;
  final String major;
  final String universityEmail;
  final String entranceYear;
  final String gpa;
  final String academicStatus;
  final String phoneNumber;
  final String personalEmail;
  final String bio;
  final List<RegisteredCourse> registeredCourses;

  StudentProfile({
    required this.fullName,
    required this.studentNumber,
    required this.major,
    required this.universityEmail,
    required this.entranceYear,
    required this.gpa,
    required this.academicStatus,
    required this.phoneNumber,
    required this.personalEmail,
    required this.bio,
    required this.registeredCourses,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      fullName: json['fullName'] ?? '',
      studentNumber: json['studentNumber'] ?? '',
      major: json['major'] ?? '',
      universityEmail: json['universityEmail'] ?? '',
      entranceYear: json['entranceYear'] ?? '',
      gpa: json['gpa'] ?? '',
      academicStatus: json['academicStatus'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      personalEmail: json['personalEmail'] ?? '',
      bio: json['bio'] ?? '',
      registeredCourses: (json['registeredCourses'] as List<dynamic>? ?? [])
          .map((c) => RegisteredCourse.fromJson(c))
          .toList(),
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'personalEmail': personalEmail,
      'bio': bio,
    };
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
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      instructor: json['instructor'] ?? '',
      units: json['units'] ?? 3,
      status: json['status'] ?? 'عضو فعال',
    );
  }
}