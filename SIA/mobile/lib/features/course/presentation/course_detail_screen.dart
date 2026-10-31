import 'package:flutter/material.dart';

class CourseDetailScreen extends StatefulWidget {
  final int courseId;
  final String title;
  final String instructor;

  const CourseDetailScreen({
    Key? key,
    required this.courseId,
    required this.title,
    required this.instructor,
  }) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> with SingleTickerProviderStateMixin {
  static const Color bgColor = Color(0xFF070D1E);
  static const Color cardColor = Color(0xFF0E1B38);
  static const Color primaryBlue = Color(0xFF1D4ED8);
  static const Color tagBlueBg = Color(0xFF1E3A8A);
  static const Color tagBlueFg = Color(0xFF93C5FD);
  static const Color memberGreen = Color(0xFF059669);

  late TabController _tabController;

  late String _schedule;
  late String _location;
  late String _about;
  late List<String> _chapters;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _setupCourseData();
  }

  void _setupCourseData() {
    switch (widget.courseId) {
      case 1: // مهندسی نرم‌افزار ۱
        _schedule = ' یکشنبه و سه‌شنبه ۰۸:۰۰ الی ۱۰:۰۰';
        _location = 'دانشکده کامپیوتر - کلاس ۱۰۴';
        _about = 'آشنایی با متدولوژی‌های چابک، چرخه حیات نرم‌افزار، تحلیل نیازمندی‌ها، مدل‌سازی با UML و اصول معماری تمیز در مهندسی نرم‌افزار.';
        _chapters = [
          'فصل ۱: مفاهیم چرخه‌های حیات و متدولوژی Scrum',
          'فصل ۲: مهندسی نیازمندی‌ها و سناریوهای کاربر',
          'فصل ۳: مدل‌سازی با نمودارهای Use Case و Activity',
          'فصل ۴: طراحی کلاس‌ها و الگوهای شی‌گرایی (SOLID)',
          'فصل ۵: تست نرم‌افزار، تضمین کیفیت و استقرار پیوسته (CI/CD)',
        ];
        break;

      case 2: // پایگاه داده‌ها
        _schedule = 'شنبه و دوشنبه ۱۳:۳۰ الی ۱۵:۳۰';
        _location = 'دانشکده کامپیوتر - کلاس ۲۰۲';
        _about = 'مفاهیم بنیادی مدل رابطه‌ای، طراحی نمودار ER، نرمال‌سازی جداول، کوئری‌نویسی پیشرفته SQL و مبانی تراکنش‌ها (ACID).';
        _chapters = [
          'فصل ۱: معماری سیستم‌های پایگاه داده و مدل داده‌ای',
          'فصل ۲: مدل‌سازی مفهومی با نمودارهای ER و EER',
          'فصل ۳: جبر رابطه‌ای و زبان پرس‌وجوی SQL استاندارد',
          'فصل ۴: نرمال‌سازی و فرم‌های نرمال (1NF تا BCNF)',
          'فصل ۵: مدیریت تراکنش‌ها، همروندی و ایندکس‌گذاری',
        ];
        break;

      case 3: // طراحی الگوریتم‌ها
        _schedule = 'دوشنبه و چهارشنبه ۰۸:۰۰ الی ۰۹:۳۰';
        _location = 'دانشکده کامپیوتر - تالار خوارزمی';
        _about = 'تحلیل پیچیدگی زمانی و مکانی، تکنیک‌های طراحی الگوریتم‌های کارآمد، برنامه‌نویسی پویا و الگوریتم‌های پیشرفته گراف.';
        _chapters = [
          'فصل ۱: تحلیل مجانبی و روابط بازگشتی (روش Master)',
          'فصل ۲: الگوریتم‌های تقسیم و حل (Divide & Conquer)',
          'فصل ۳: روش‌های حریصانه (Greedy) و درخت پوشای کمینه',
          'فصل ۴: برنامه‌نویسی پویا (Dynamic Programming)',
          'فصل ۵: الگوریتم‌های گراف و مسائل NP-Complete',
        ];
        break;

      case 4: // شبکه‌های کامپیوتری
      default:
        _schedule = 'شنبه و چهارشنبه ۱۴:۰۰ الی ۱۵:۳۰';
        _location = 'دانشکده کامپیوتر - سایت شبکه';
        _about = 'بررسی معماری لایه‌ای اینترنت، پروتکل‌های لایه انتقال و شبکه، مسیریابی، امنیت شبکه و برنامه‌نویسی سوکت.';
        _chapters = [
          'فصل ۱: مدل‌های مرجع OSI و TCP/IP و لایه کاربرد (HTTP, DNS)',
          'فصل ۲: لایه انتقال، پروتکل‌های TCP/UDP و کنترل ازدحام',
          'فصل ۳: لایه شبکه، آدرس‌دهی IPv4/IPv6 و الگوریتم‌های مسیریابی',
          'فصل ۴: لایه پیوند داده، اترنت و پروتکل‌های کنترل دسترسی',
          'فصل ۵: امنیت در شبکه‌ها، رمزنگاری و فایروال‌ها',
        ];
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
          
        ),
        body: Column(
          children: [
            _buildCourseHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCourseInfoTab(),
                  _buildPlaceholderTab('منابع و جزوات درس به زودی بارگذاری می‌شود.'),
                  _buildPlaceholderTab('تالار گفتگوی دانشجویان و استاد'),
                  _buildPlaceholderTab('بخش نظرسنجی و ارزیابی استاد'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'مدرس: ${widget.instructor}',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF60A5FA), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: memberGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'عضو درس',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 14, color: Colors.white60),
              const SizedBox(width: 4),
              Text(_schedule, style: const TextStyle(fontSize: 11, color: Colors.white60)),
              const SizedBox(width: 14),
              const Icon(Icons.location_on_outlined, size: 14, color: Colors.white60),
              const SizedBox(width: 4),
              Text(_location, style: const TextStyle(fontSize: 11, color: Colors.white60)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12, width: 1)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: const Color(0xFF38BDF8),
        indicatorWeight: 3,
        labelColor: const Color(0xFF38BDF8),
        unselectedLabelColor: Colors.white60,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        tabs: const [
          Tab(text: 'اطلاعات درس'),
          Tab(text: 'منابع و جزوات'),
          Tab(text: 'تالار گفتگو'),
          Tab(text: 'ارزیابی استاد'),
        ],
      ),
    );
  }

  Widget _buildCourseInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('درباره درس', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              Text(_about, style: const TextStyle(fontSize: 12, height: 1.7, color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('سرفصل‌های آموزشی', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 12),
              ...List.generate(
                _chapters.length,
                (index) => _buildChapterRow(index + 1, _chapters[index]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChapterRow(int number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: primaryBlue,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
      ),
    );
  }
}
