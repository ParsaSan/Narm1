import 'package:flutter/material.dart';
import '../data/course_detail_api_service.dart';

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
  static const Color memberGreen = Color(0xFF059669);

  final _api = CourseDetailApiService();
  late TabController _tabController;

  CourseDetail? _course;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadCourse();
  }

  Future<void> _loadCourse() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final c = await _api.getDetail(widget.courseId);
      if (!mounted) return;
      setState(() {
        _course = c;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
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
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
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
    final c = _course;
    final title = c?.title ?? widget.title;
    final instructor = c?.instructor ?? widget.instructor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'مدرس: $instructor',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF60A5FA), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: memberGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
          if (c != null && (c.schedule.isNotEmpty || c.location.isNotEmpty)) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 14,
              runSpacing: 6,
              children: [
                if (c.schedule.isNotEmpty) _buildMeta(Icons.access_time_rounded, c.schedule),
                if (c.location.isNotEmpty) _buildMeta(Icons.location_on_outlined, c.location),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMeta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white60),
        const SizedBox(width: 4),
        Flexible(
          child: Text(text, style: const TextStyle(fontSize: 11, color: Colors.white60)),
        ),
      ],
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final c = _course;
    if (_error != null || c == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, color: Colors.white54, size: 40),
              const SizedBox(height: 12),
              Text(
                _error ?? 'خطای نامشخص',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadCourse,
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

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCard(
          title: 'درباره درس',
          child: Text(
            c.about.isEmpty ? 'توضیحاتی برای این درس ثبت نشده است.' : c.about,
            style: const TextStyle(fontSize: 12, height: 1.7, color: Colors.white70),
          ),
        ),
        const SizedBox(height: 16),
        _buildCard(
          title: 'سرفصل‌های آموزشی',
          child: c.chapters.isEmpty
              ? const Text(
                  'سرفصلی برای این درس ثبت نشده است.',
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                )
              : Column(
                  children: List.generate(
                    c.chapters.length,
                    (index) => _buildChapterRow(index + 1, c.chapters[index]),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          child,
        ],
      ),
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