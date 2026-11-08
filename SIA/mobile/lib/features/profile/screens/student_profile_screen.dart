
import 'package:flutter/material.dart';
import '../models/student_profile_model.dart';
import '../services/profile_api_service.dart';
import '../widgets/edit_profile_sheet.dart';
import '../../course/presentation/course_detail_screen.dart';
import '../../../core/app_routes.dart';
import '../../auth/state/auth_controller.dart';
 
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
 
  final _api = ProfileApiService();
 
  StudentProfile? profile;
  bool isLoading = true;
  String? error;
 
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }
 
  Future<void> _loadProfile() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final p = await _api.getProfile();
      if (!mounted) return;
      setState(() {
        profile = p;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }
 
  Future<void> _openEditProfileDialog() async {
    final current = profile;
    if (current == null) return;
 
    final updatedProfile = await showModalBottomSheet<StudentProfile>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProfileSheet(initialProfile: current),
    );
 
    if (!mounted) return;
 
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
        body: _buildBody(),
      ),
    );
  }
 
  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
 
    final p = profile;
    if (error != null || p == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, color: Colors.white54, size: 40),
              const SizedBox(height: 12),
              Text(
                error ?? 'خطای نامشخص',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadProfile,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('تلاش مجدد'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }
 
    return RefreshIndicator(
      onRefresh: _loadProfile,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeaderCard(p),
          const SizedBox(height: 20),
          const Text('اطلاعات رسمی آموزشی (سامانه آموزش دانشگاه)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70)),
          const SizedBox(height: 10),
          _buildOfficialInfoCard(p),
          const SizedBox(height: 24),
          Text('دروس ثبت‌شده دانشجو (${p.registeredCourses.length} درس)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70)),
          const SizedBox(height: 10),
          ...p.registeredCourses.map((c) => _buildCourseCard(c)),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            // خروج از حساب: کاربر را خارج می‌کند و به صفحه‌ی خوش‌آمد برمی‌گرداند
            onPressed: () {
              authController.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.welcome, (_) => false);
            },
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
    );
  }
 
  Widget _buildHeaderCard(StudentProfile p) {
    final name = p.fullName.trim();
    final firstLetter = name.isNotEmpty ? name.substring(0, 1) : 'س';
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
          Text(p.fullName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
          if (p.bio.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              p.bio,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.white60, height: 1.5),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadge(
                p.studentType.isNotEmpty ? p.studentType : 'دانشجوی رسمی',
                const Color(0xFF065F46),
                const Color(0xFF34D399),
              ),
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
 
  Widget _buildOfficialInfoCard(StudentProfile p) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          _buildInfoRow('شماره دانشجویی', p.studentNumber, Icons.badge_outlined, hasOfficialBadge: true),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow('رشته و گرایش', p.major, Icons.school_outlined),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow('ایمیل دانشگاهی', p.universityEmail, Icons.mail_outline),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow('سال ورود', p.entryYear.toString(), Icons.calendar_today_outlined),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow('معدل کل رسمی', p.gpa.toStringAsFixed(2), Icons.star_outline_rounded, hasOfficialBadge: true),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow('وضعیت تحصیلی', p.educationStatus, Icons.verified_user_outlined, hasOfficialBadge: true),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow('شماره همراه', p.phone.isEmpty ? '—' : p.phone, Icons.phone_outlined),
          const Divider(color: Colors.white12, height: 1),
          _buildInfoRow('ایمیل شخصی', p.personalEmail.isEmpty ? '—' : p.personalEmail, Icons.alternate_email_rounded),
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
 

