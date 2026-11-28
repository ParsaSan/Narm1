import 'package:flutter/material.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/layout/sia_app_bar.dart';
import '../../auth/state/auth_controller.dart';
import '../../course/data/course_api_service.dart';
import '../../course/data/course_model.dart';
import '../data/resource_model.dart';
import '../data/resource_repository.dart';
import '../upload/upload_resource_screen.dart';
import 'widgets/resource_card.dart';

/// صفحه بانک جزوه‌ها، جست‌وجو، فیلتر و دانلود امن (اسپرینت ۲)
class ResourceBankScreen extends StatefulWidget {
  const ResourceBankScreen({super.key});

  @override
  State<ResourceBankScreen> createState() => _ResourceBankScreenState();
}

class _ResourceBankScreenState extends State<ResourceBankScreen> {
  final ResourceRepository _repo = ResourceRepository();
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _fileTypes = ['همه', 'PDF', 'DOCX', 'ZIP', 'تصویر'];

  bool _isLoading = true;
  String? _errorMessage;

  List<ResourceItem> _resources = [];
  List<Course> _courses = [];
  final Set<int> _downloadingIds = {};

  int? _selectedCourseId;
  String _selectedFileType = 'همه';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadCoursesForFilter(),
      _loadResources(),
    ]);
  }

  Future<void> _loadCoursesForFilter() async {
    try {
      final list = await CourseApiService.fetchCourses();
      if (!mounted) return;
      setState(() => _courses = list);
    } catch (_) {
      // اگر سرور روشن نبود، لیست فیلتر خالی می‌ماند یا فقط از جزوه‌ها استخراج می‌شود
    }
  }

  Future<void> _loadResources() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final currentUserId = authController.user?.id;
      final list = await _repo.fetchResources(
        query: _searchController.text,
        courseId: _selectedCourseId,
        fileType: _selectedFileType,
        currentUserId: currentUserId,
      );
      if (!mounted) return;
      setState(() {
        _resources = list;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'خطای غیرمنتظره در دریافت لیست جزوه‌ها رخ داد.';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleDownload(ResourceItem item) async {
    setState(() => _downloadingIds.add(item.id));

    try {
      final currentUserId = authController.user?.id;
      await _repo.downloadResource(item, currentUserId: currentUserId);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.teamBg,
          content: Text(
            'جزوه «${item.title}» (${item.formattedSize}) با موفقیت دانلود شد.',
            style: const TextStyle(color: AppColors.teamIcon),
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.errorBg,
          content: Text(
            e.message,
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _downloadingIds.remove(item.id));
      }
    }
  }

  Future<void> _handleDelete(ResourceItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('حذف جزوه', style: TextStyle(fontSize: 16)),
          content: Text(
            'آیا از حذف جزوه «${item.title}» مطمئن هستید؟ این عملیات قابل بازگشت نیست.',
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('انصراف'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'بله، حذف شود',
                style: TextStyle(color: AppColors.onError),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;

    try {
      await _repo.deleteResource(item.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('جزوه با موفقیت حذف شد.')),
      );
      _loadResources();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.errorBg,
          content: Text(
            e.message,
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = authController.user?.id;

    // ساخت لیست یکتا برای منوی انتخاب درس (از سرور یا از جزوه‌های موجود)
    final courseOptions = <int, String>{};
    for (final c in _courses) {
      courseOptions[c.id] = c.title;
    }
    if (courseOptions.isEmpty) {
      for (final r in _resources) {
        courseOptions[r.courseId] = r.courseName;
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const SiaAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const UploadResourceScreen(),
              ),
            );
            _loadResources();
          },
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.upload_file_rounded),
          label: const Text('آپلود جزوه'),
        ),
        body: Column(
          children: [
            // بخش جست‌وجو و فیلترها
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  bottom: BorderSide(color: AppColors.outline, width: 0.6),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // باکس جست‌وجو
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => _loadResources(),
                    decoration: InputDecoration(
                      hintText: 'جست‌وجو در عنوان یا توضیحات جزوه‌ها...',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textSecondary,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _loadResources();
                        },
                      )
                          : null,
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.outline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // منوی کشویی فیلتر بر اساس درس
                  DropdownButtonFormField<int?>(
                    value: courseOptions.containsKey(_selectedCourseId)
                        ? _selectedCourseId
                        : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.outline),
                      ),
                    ),
                    dropdownColor: AppColors.surface,
                    hint: const Text(
                      'همه دروس',
                      style: TextStyle(fontSize: 13),
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('همه دروس', style: TextStyle(fontSize: 13)),
                      ),
                      ...courseOptions.entries.map(
                            (e) => DropdownMenuItem<int?>(
                          value: e.key,
                          child: Text(
                            e.value,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() => _selectedCourseId = val);
                      _loadResources();
                    },
                  ),
                  const SizedBox(height: 10),

                  // دکمه‌های فیلتر نوع فایل
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _fileTypes.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final type = _fileTypes[index];
                        final selected = _selectedFileType == type;
                        return ChoiceChip(
                          label: Text(
                            type,
                            style: TextStyle(
                              fontSize: 12,
                              color: selected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                          selected: selected,
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.background,
                          side: const BorderSide(color: AppColors.outline),
                          onSelected: (_) {
                            setState(() => _selectedFileType = type);
                            _loadResources();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // بخش لیست جزوه‌ها
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? _buildErrorView()
                  : _resources.isEmpty
                  ? _buildEmptyView()
                  : RefreshIndicator(
                onRefresh: _loadResources,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    90,
                  ),
                  itemCount: _resources.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _resources[index];
                    final isOwner = currentUserId != null &&
                        item.uploaderId == currentUserId;
                    return ResourceCard(
                      resource: item,
                      isOwner: isOwner,
                      isDownloading:
                      _downloadingIds.contains(item.id),
                      onDownload: () => _handleDownload(item),
                      onDelete: isOwner
                          ? () => _handleDelete(item)
                          : null,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.library_books_outlined,
              size: 56,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            const Text(
              'جزوه‌ای با این مشخصات پیدا نشد.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            if (_searchController.text.isNotEmpty ||
                _selectedCourseId != null ||
                _selectedFileType != 'همه')
              TextButton.icon(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _selectedCourseId = null;
                    _selectedFileType = 'همه';
                  });
                  _loadResources();
                },
                icon: const Icon(Icons.filter_alt_off_rounded),
                label: const Text('پاک کردن فیلترها'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 56,
              color: AppColors.error,
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? 'خطای ناشناخته',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadResources,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('تلاش مجدد'),
            ),
          ],
        ),
      ),
    );
  }
}