import 'package:flutter/material.dart';

import '../../features/course/presentation/course_list_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/profile/screens/student_profile_screen.dart';
import 'placeholder_page.dart';

class _Tab {
  const _Tab(this.label, this.icon, this.selectedIcon, this.page);
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;
}

/// صفحه‌ی اصلی بعد از ورود: منوی پایین با ۵ تب.
/// هر تب صفحه‌ی خودش را با هدر خودش نشان می‌دهد.
/// ترتیب از راست به چپ است (اولین آیتم = سمت راست).
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _index = 0;

  /// هر تب فقط وقتی اولین بار باز شد ساخته می‌شود
  /// تا همه‌ی صفحه‌ها هم‌زمان از سرور داده نگیرند.
  final Set<int> _opened = {0};

  static const _tabs = <_Tab>[
    _Tab('داشبورد', Icons.home_outlined, Icons.home_rounded, DashboardScreen()),
    _Tab('دروس', Icons.menu_book_outlined, Icons.menu_book_rounded, CourseListScreen()),
    _Tab('تکالیف', Icons.assignment_outlined, Icons.assignment_rounded,
        PlaceholderPage(title: 'تکالیف', icon: Icons.assignment_rounded)),
    _Tab('منابع', Icons.library_books_outlined, Icons.library_books_rounded,
        PlaceholderPage(title: 'منابع', icon: Icons.library_books_rounded)),
    _Tab('پروفایل', Icons.person_outline_rounded, Icons.person_rounded,
        StudentProfileScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          for (var i = 0; i < _tabs.length; i++)
            _opened.contains(i) ? _tabs[i].page : const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() {
          _index = i;
          _opened.add(i);
        }),
        destinations: [
          for (final t in _tabs)
            NavigationDestination(
              icon: Icon(t.icon),
              selectedIcon: Icon(t.selectedIcon),
              label: t.label,
            ),
        ],
      ),
    );
  }
}