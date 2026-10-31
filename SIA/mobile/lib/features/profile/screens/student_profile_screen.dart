import 'package:flutter/material.dart';
import '../models/student_profile_model.dart';
import '../../course/presentation/course_detail_screen.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  static const Color bgColor = Color(0xFF070D1E);
  static const Color cardColor = Color(0xFF0E1B38);
  static const Color primaryBlue = Color(0xFF1D4ED8);
  static const Color avatarBg = Color(0xFF6EA8FE);
  static const Color officialTagBg = Color(0xFF162544);

  late StudentProfile profile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialProfile();
  }

  void _loadInitialProfile() {
    profile = StudentProfile(
      fullName: 'سارا احمدی',
      studentNumber: '40123456',
      major: 'مهندسی کامپیوتر - نرم‌افزار',
      universityEmail: 'aut.ac.ir@40123456',
      entranceYear: '1401',
      gpa: '18.45 (الف)',
      academicStatus: 'در حال تحصیل (مجاز به انتخاب واحد)',
      phoneNumber: '09121234567',
      personalEmail: 'sara.ahmadi@gmail.com',
      bio: 'دانشجوی مهندسی کامپیوتر، علاقه‌مند به توسعه نرم‌افزار',
      registeredCourses: [
        RegisteredCourse(id: 1, title: 'مهندسی نرم‌افزار ۱', instructor: 'دکتر مریم رضایی', units: 3, status: 'عضو فعال'),
        RegisteredCourse(id: 2, title: 'پایگاه داده‌ها', instructor: 'دکتر علی کاظمی', units: 3, status: 'عضو فعال'),
        RegisteredCourse(id: 3, title: 'طراحی الگوریتم‌ها', instructor: 'دکتر حمید هاشمی', units: 3, status: 'عضو فعال'),
        RegisteredCourse(id: 4, title: 'شبکه‌های کامپیوتری', instructor: 'دکتر بهزاد میرزایی', units: 3, status: 'عضو فعال'),
      ],
    );
  }

  void _openEditProfileDialog() async {
    final updatedProfile = await showModalBottomSheet<StudentProfile>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProfileSheet(initialProfile: profile),
    );

    if (updatedProfile != null) {
      setState(() {
        profile = updatedProfile;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('مشخصات دانشجویی با موفقیت ذخیره شد.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          title: Row(
            children: [
              const Text('پروفایل تحصیلی دانشجو', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFF1E3A8A), borderRadius: BorderRadius.circular(12)),
                child: const Text('اسپرینت ۱', style: TextStyle(fontSize: 10, color: Color(0xFF93C5FD), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 20),
            const Text('اطلاعات رسمی آموزشی (سامانه آموزش دانشگاه)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70)),
            const SizedBox(height: 10),
            _buildOfficialInfoCard(),
            const SizedBox(height: 24),
            Text('دروس ثبت‌شده دانشجو (${profile.registeredCourses.length} درس)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70)),
            const SizedBox(height: 10),
            ...profile.registeredCourses.map((c) => _buildCourseCard(c)).toList(),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout_rounded, size: 18, color: Colors.grey),
              label: const Text('خروج از حساب کاربری', style: TextStyle(color: Colors.grey, fontSize: 13)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1F2937)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final firstLetter = profile.fullName.trim().isNotEmpty ? profile.fullName.trim().substring(0, 1) : 'س';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: avatarBg,
            child: Text(firstLetter, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
          const SizedBox(height: 10),
          Text(profile.fullName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadge('دانشجوی رسمی', const Color(0xFF065F46), const Color(0xFF34D399)),
              const SizedBox(width: 8),
              _buildBadge('نسخه نمایشی اسپرینت ۱', const Color(0xFF1E3A8A), const Color(0xFF93C5FD)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: _openEditProfileDialog,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('ویرایش مشخصات دانشجویی', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficialInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          _buildInfoRow('شماره دانشجویی', profile.studentNumber, Icons.badge_outlined, hasOfficialBadge: true),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow('رشته و گرایش', profile.major, Icons.school_outlined),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow('ایمیل دانشگاهی', profile.universityEmail, Icons.mail_outline),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow('سال ورود', profile.entranceYear, Icons.calendar_today_outlined),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow('معدل کل رسمی', profile.gpa, Icons.star_outline_rounded, hasOfficialBadge: true),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow('وضعیت تحصیلی', profile.academicStatus, Icons.verified_user_outlined, hasOfficialBadge: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {bool hasOfficialBadge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if (hasOfficialBadge)
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: officialTagBg, borderRadius: BorderRadius.circular(4)),
                    child: const Text('رسمی', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ),
                Expanded(
                  child: Text(value, style: const TextStyle(fontSize: 12, color: Colors.white), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
              const SizedBox(width: 8),
              Icon(icon, size: 18, color: Colors.blue.shade400),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(RegisteredCourse course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // فرستادن اطلاعات درس به صفحه اختصاصی خودش
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailScreen(
                  courseId: course.id,
                  title: course.title,
                  instructor: course.instructor,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFF064E3B), borderRadius: BorderRadius.circular(6)),
                  child: Text(course.status, style: const TextStyle(fontSize: 10, color: Color(0xFF6EE7B7), fontWeight: FontWeight.bold)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text('${course.instructor} • ${course.units} واحد', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(fontSize: 10, color: fg, fontWeight: FontWeight.w600)),
    );
  }
}

// ویجت شیت ویرایش اطلاعات دانشجو
class EditProfileSheet extends StatefulWidget {
  final StudentProfile initialProfile;
  const EditProfileSheet({Key? key, required this.initialProfile}) : super(key: key);

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  static const Color bgColor = Color(0xFF0E1B38);
  static const Color inputBg = Color(0xFF070D1E);
  static const Color primaryBlue = Color(0xFF1D4ED8);

  late TextEditingController _phoneController;
  late TextEditingController _personalEmailController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.initialProfile.phoneNumber);
    _personalEmailController = TextEditingController(text: widget.initialProfile.personalEmail);
    _bioController = TextEditingController(text: widget.initialProfile.bio);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _personalEmailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updated = StudentProfile(
      fullName: widget.initialProfile.fullName,
      studentNumber: widget.initialProfile.studentNumber,
      major: widget.initialProfile.major,
      universityEmail: widget.initialProfile.universityEmail,
      entranceYear: widget.initialProfile.entranceYear,
      gpa: widget.initialProfile.gpa,
      academicStatus: widget.initialProfile.academicStatus,
      phoneNumber: _phoneController.text.trim(),
      personalEmail: _personalEmailController.text.trim(),
      bio: _bioController.text.trim(),
      registeredCourses: widget.initialProfile.registeredCourses,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        decoration: const BoxDecoration(color: bgColor, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 16),
              const Text('ویرایش مشخصات فردی', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('اطلاعات رسمی دانشگاهی توسط آموزش قفل شده و فقط اطلاعات ارتباطی قابل ویرایش است.', style: TextStyle(color: Colors.white60, fontSize: 11)),
              const SizedBox(height: 20),
              _buildTextField('شماره همراه', _phoneController, TextInputType.phone),
              const SizedBox(height: 14),
              _buildTextField('ایمیل شخصی', _personalEmailController, TextInputType.emailAddress),
              const SizedBox(height: 14),
              _buildTextField('درباره من (بیوگرافی)', _bioController, TextInputType.multiline, maxLines: 3),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('ذخیره تغییرات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType type, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: type,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: inputBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white10)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: primaryBlue)),
          ),
        ),
      ],
    );
  }
}
