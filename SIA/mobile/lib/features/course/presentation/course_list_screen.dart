import 'package:flutter/material.dart';
import '../data/course_model.dart';
import 'widgets/course_card.dart';
import 'course_detail_screen.dart'; // فایل پارسا

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  static const _filters = ['همه', 'تخصصی', 'پایه', 'عمومی'];

  String _selectedFilter = 'همه';
  String _query = '';

  // داده‌ی آزمایشی؛ بعداً با GET /api/courses جایگزین می‌شود
  final List<Course> _allCourses = const [
    Course(
      id: 1, code: 'CE-401', title: 'مهندسی نرم‌افزار ۱',
      englishTitle: 'Software Engineering I',
      description: 'آشنایی با متدولوژی‌های چابک، چرخه حیات نرم‌افزار، تحلیل نیازمندی‌ها، مدل‌سازی با UML و اصول معماری تمیز در مهندسی نرم‌افزار.',
      units: 3, type: 'تخصصی', instructor: 'دکتر مریم رضایی', isEnrolled: true,
    ),
    Course(
      id: 2, code: 'CE-402', title: 'پایگاه داده‌ها',
      englishTitle: 'Database Systems',
      description: 'مفاهیم بنیادی سیستم‌های مدیریت پایگاه داده رابطه‌ای، مدل‌سازی ER، جبر رابطه‌ای، زبان SQL و نرمال‌سازی جداول.',
      units: 3, type: 'تخصصی', instructor: 'دکتر علی کاظمی', isEnrolled: true,
    ),
    Course(
      id: 3, code: 'CE-403', title: 'طراحی الگوریتم‌ها',
      englishTitle: 'Design and Analysis of Algorithms',
      description: 'تحلیل مجانبی زمان و فضای الگوریتم‌ها، روش تقسیم و حل، روش حریصانه، برنامه‌نویسی پویا و الگوریتم‌های گراف.',
      units: 3, type: 'تخصصی', instructor: 'دکتر حمید هاشمی', isEnrolled: true,
    ),
    Course(
      id: 4, code: 'CE-404', title: 'شبکه‌های کامپیوتری',
      englishTitle: 'Computer Networks',
      description: 'بررسی لایه‌ای معماری شبکه بر مبنای مدل اینترنت و OSI، پروتکل‌های لایه کاربرد، انتقال (TCP/UDP)، شبکه (IP) و پیوند داده.',
      units: 3, type: 'تخصصی', instructor: 'دکتر بهزاد میرزایی', isEnrolled: true,
    ),
    Course(
      id: 5, code: 'CE-501', title: 'هوش مصنوعی و سیستم‌های خبره',
      englishTitle: 'Artificial Intelligence',
      description: 'عامل‌های هوشمند، جستجوهای آگاهانه و ناآگاهانه، مسائل ارضای محدودیت (CSP)، بازی‌ها و مبانی یادگیری ماشین.',
      units: 3, type: 'تخصصی', instructor: 'دکتر نرگس سلیمانی',
    ),
    Course(
      id: 6, code: 'CE-405', title: 'سیستم‌های عامل',
      englishTitle: 'Operating Systems',
      description: 'مدیریت پردازه‌ها و نخ‌ها، زمان‌بندی CPU، همگام‌سازی و بن‌بست، مدیریت حافظه اصلی و حافظه مجازی.',
      units: 3, type: 'تخصصی', instructor: 'دکتر یزدان نادری',
    ),
    Course(
      id: 7, code: 'CE-101', title: 'مبانی برنامه‌نویسی',
      englishTitle: 'Fundamentals of Programming',
      description: 'آموزش اصول الگوریتم، متغیرها، ساختارهای کنترلی، توابع، آرایه‌ها، اشاره‌گرها و ورودی/خروجی فایل به زبان C/C++.',
      units: 3, type: 'پایه', instructor: 'مهندس کیانپور',
    ),
    Course(
      id: 8, code: 'GEN-201', title: 'زبان تخصصی کامپیوتر',
      englishTitle: 'Technical English for Computer Engineers',
      description: 'متون تخصصی علوم کامپیوتر، اصطلاحات مهندسی نرم‌افزار، شبکه، نگارش رزومه و مقالات علمی فنی.',
      units: 2, type: 'عمومی', instructor: 'دکتر فیروزبخش',
    ),
  ];

  // یکسان‌سازی «ي/ك» عربی با «ی/ک» فارسی تا جستجو دقیق‌تر شود
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
        ),
        body: Center(
          // روی صفحه‌های عریض، لیست کش نمی‌آید
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                // نوار جستجوی زنده
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
                        borderSide:
                            BorderSide(color: cs.outlineVariant.withOpacity(0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: cs.outlineVariant.withOpacity(0.5)),
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
                      'تعداد دروس یافت‌شده: ${courses.length} درس',
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
    );
  }
}