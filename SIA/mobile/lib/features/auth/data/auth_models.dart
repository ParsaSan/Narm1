
/// کاربر واردشده؛ مطابق AuthResponse.java بک‌اند.
class AppUser {
  const AppUser({
    required this.firstName,
    required this.lastName,
    required this.studentNumber,
    this.id,
  });

  final int? id;
  final String firstName;
  final String lastName;
  final String studentNumber;

  String get fullName => '$firstName $lastName'.trim();

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: (json['id'] as num?)?.toInt(),
        firstName: (json['firstName'] ?? '').toString(),
        lastName: (json['lastName'] ?? '').toString(),
        studentNumber: (json['studentNumber'] ?? '').toString(),
      );

  /// کاربر نسخه دمو (بدون سرور).
  static const demo = AppUser(
    id: 0,
    firstName: 'سارا',
    lastName: 'احمدی',
    studentNumber: '401123456',
  );
}
