import 'package:flutter/material.dart';

// ایمپورت صفحه پروفایل (مطابق با ساختار پوشه features/profile)
import 'features/profile/screens/student_profile_screen.dart';
// ایمپورت صفحه کاتالوگ دوره‌ها

void main() {
  runApp(const SiamApp());
}

class SiamApp extends StatelessWidget {
  const SiamApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سامانه دانشگاهی SIA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF070D1E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1D4ED8),
          surface: Color(0xFF0E1B38),
        ),
        useMaterial3: true,
      ),
      // برای نمایش مستقیم صفحه پروفایل دانشجو:
      home: const StudentProfileScreen(),

      // اگر خواستید لیست دوره‌ها را ببینید، خط بالا را کامنت کنید و خط زیر را فعال کنید:
      // home: const CourseListScreen(),
    );
  }
}
