import 'package:flutter/material.dart';
import '../course/presentation/course_detail_screen.dart';
import '../course/presentation/course_list_screen.dart';
import '../profile/screens/student_profile_screen.dart';
import 'dashboard_models.dart';
import 'dashboard_api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardApiService _apiService = DashboardApiService();

  bool _isLoading = true;
  String? _errorMessage;

  DashboardStatsModel? _stats;
  List<BannerModel> _banners = [];
  List<RecentCourseModel> _recentCourses = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final stats = await _apiService.fetchStats();
      final banners = await _apiService.fetchBanners();
      final recentCourses = await _apiService.fetchRecentCourses();

      setState(() {
        _stats = stats;
        _banners = banners;
        _recentCourses = recentCourses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'امکان اتصال به سرور وجود ندارد. آیا سرور روشن است؟';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('دستیار هوشمند دانشجویی'),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outline),
              tooltip: 'پروفایل دانشجو',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? _buildErrorView()
            : RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(),
                const SizedBox(height: 20),
                _buildStatsSection(),
                const SizedBox(height: 25),
                _buildBannersSection(),
                const SizedBox(height: 25),
                _buildRecentCoursesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'سلام، دانشجو عزیز! 👋',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            'به سامانه یکپارچه دروس و منابع خوش آمدید.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildAdvancedStatCard(
            title: 'ترم ${_stats?.currentTerm ?? 5}',
            subtitle: '${_stats?.passedUnits ?? 0} واحد گذرانده',
            icon: Icons.calendar_today,
            tag: 'ترم جاری',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildAdvancedStatCard(
            title: '${_stats?.currentTermUnits ?? 0} واحد',
            subtitle: '${_stats?.currentTermCoursesCount ?? 0} درس انتخابی',
            icon: Icons.assignment_outlined,
            tag: 'واحدهای ترم',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: _showGpaChartDialog,
            borderRadius: BorderRadius.circular(12),
            child: _buildAdvancedStatCard(
              title: _stats?.gpaTrend ?? 'صعودی',
              subtitle: 'مشاهده نمودار معدل 📊',
              icon: Icons.trending_up,
              tag: 'عملکرد تحصیلی',
              isClickable: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedStatCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String tag,
    bool isClickable = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isClickable ? Colors.blue.withOpacity(0.5) : Colors.white10,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18),
              const SizedBox(width: 4),
              Text(
                tag,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
                maxLines: 1,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: isClickable ? Colors.lightBlueAccent : Colors.white70,
              fontWeight: isClickable ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showGpaChartDialog() {
    final gpas = _stats?.pastTermGpas ?? [15.5, 16.2, 16.8, 17.1, 17.75];

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.insights, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text('نمودار روند معدل ترم‌ها', style: TextStyle(fontSize: 16)),
              ],
            ),
            content: SizedBox(
              width: 320,
              height: 200,
              child: Column(
                children: [
                  const Text(
                    'روند پیشرفت معدل در ترم‌های گذشته:',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(gpas.length, (index) {
                        final gpa = gpas[index];
                        final barHeight = (gpa / 20.0) * 110.0;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              gpa.toString(),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 24,
                              height: barHeight,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.blueAccent, Colors.cyanAccent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'ترم ${index + 1}',
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('بستن'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBannersSection() {
    if (_banners.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اطلاعیه‌ها و بنرها',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _banners.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                width: 260,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      Theme.of(context).colorScheme.primary.withOpacity(0.4),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      banner.title,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      banner.subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentCoursesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'آخرین دروس مشاهده‌شده',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // ۱. با زدن این دکمه و برگشتن، داشبورد خودکار رفرش می‌شود
            TextButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CourseListScreen(),
                  ),
                );
                _loadDashboardData();
              },
              icon: const Icon(Icons.list, size: 16),
              label: const Text('همه دروس', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_recentCourses.isEmpty)
          const Text('هنوز درسی مشاهده نشده است.', style: TextStyle(color: Colors.grey))
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentCourses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final course = _recentCourses[index];
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                // ۲. با کلیک روی هر درس و برگشتن، داشبورد خودکار رفرش می‌شود
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailScreen(
                        courseId: course.id,
                        title: course.title,
                        instructor: course.instructor,
                      ),
                    ),
                  );
                  _loadDashboardData();
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        child: Icon(Icons.school, color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'استاد: ${course.instructor}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 60, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'خطایی رخ داد',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadDashboardData,
              icon: const Icon(Icons.refresh),
              label: const Text('تلاش مجدد'),
            ),
          ],
        ),
      ),
    );
  }
}