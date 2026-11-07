import 'package:flutter/material.dart';
import '../data/course_model.dart';
import '../data/course_api_service.dart';
import 'widgets/course_card.dart';
import 'course_detail_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  static const _filters = ['همه', 'تخصصی', 'پایه', 'عمومی'];

  String _selectedFilter = 'همه';
  String _query = '';

  // لیست دروس که از سرور دریافت می‌شود
  List<Course> _allCourses = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCoursesFromServer();
  }

  // دریافت اطلاعات زنده از بک‌اند اسپرینگ‌بوت
  Future<void> _fetchCoursesFromServer() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final courses = await CourseApiService.fetchCourses();
      setState(() {
        _allCourses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'خطا در برقراری ارتباط با سرور. آیا بک‌اند روشن است؟';
        _isLoading = false;
      });
    }
  }

  // یکسان‌سازی حروف عربی و فارسی برای جستجوی دقیق‌تر
  String _norm(String s) => s
      .replaceAll('ي', 'ی')
      .replaceAll('ك', 'ک')
      .toLowerCase()
      .trim();

  List<Course> get _filtered {
    final q = _norm(_query);
    return _allCourses.where((c) {
      final okType = _selectedFilter == 'همه' || c.type == _selectedFilter;
      final okSearch = q.isEmpty ||
          _norm(c.title).contains(q) ||
          _norm(c.englishTitle).contains(q) ||
          _norm(c.instructor).contains(q) ||
          _norm(c.code).contains(q);
      return okType && okSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final courses = _filtered;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'فهرست دروس دانشگاهی',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'بروزرسانی از سرور',
              onPressed: _fetchCoursesFromServer,
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: _isLoading
                // حالت در حال بارگذاری از سرور
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    // حالت بروز خطا در اتصال به بک‌اند
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(_errorMessage!, style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _fetchCoursesFromServer,
                              icon: const Icon(Icons.refresh),
                              label: const Text('تلاش مجدد'),
                            ),
                          ],
                        ),
                      )
                    // نمایش لیست بعد از دریافت موفقیت‌آمیز
                    : RefreshIndicator(
                        onRefresh: _fetchCoursesFromServer,
                        child: Column(
                          children: [
                            // کادر جستجو
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                              child: TextField(
                                onChanged: (v) => setState(() => _query = v),
                                decoration: InputDecoration(
                                  hintText: 'جستجوی نام درس، استاد یا کد درس...',
                                  hintStyle: const TextStyle(fontSize: 13),
                                  suffixIcon: const Icon(Icons.search),
                                  filled: true,
                                  fillColor: cs.surfaceContainer,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                        color: cs.outlineVariant.withOpacity(0.5)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                        color: cs.outlineVariant.withOpacity(0.5)),
                                  ),
                                ),
                              ),
                            ),

                            // چیپ‌های فیلتر
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: _filters.map((f) {
                                  return Padding(
                                    padding: const EdgeInsetsDirectional.only(end: 8),
                                    child: ChoiceChip(
                                      label: Text(f),
                                      selected: _selectedFilter == f,
                                      showCheckmark: false,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      onSelected: (_) =>
                                          setState(() => _selectedFilter = f),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            // تعداد نتایج
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  'تعداد دروس دریافتی از سرور: ${courses.length} درس',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: cs.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ),

                            // لیست دروس
                            Expanded(
                              child: courses.isEmpty
                                  ? const Center(child: Text('درسی پیدا نشد'))
                                  : ListView.separated(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: courses.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 12),
                                      itemBuilder: (context, i) {
                                        final course = courses[i];
                                        return CourseCard(
                                          course: course,
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => CourseDetailScreen(
                                                courseId: course.id,
                                                title: course.title,
                                                instructor: course.instructor,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}