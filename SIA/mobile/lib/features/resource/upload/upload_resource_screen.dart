import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/file_validator.dart';
import '../../../core/utils/persian_digits.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/layout/sia_app_bar.dart';
import '../../../shared/widgets/form_error_banner.dart';
import '../../../shared/widgets/submit_button.dart';
import '../../auth/state/auth_controller.dart';
import '../../course/data/course_api_service.dart';
import '../../course/data/course_model.dart';
import '../data/resource_repository.dart';

class UploadResourceScreen extends StatefulWidget {
  const UploadResourceScreen({super.key});

  @override
  State<UploadResourceScreen> createState() => _UploadResourceScreenState();
}

class _UploadResourceScreenState extends State<UploadResourceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _repo = ResourceRepository();

  List<Course> _courses = [];
  bool _loadingCourses = true;
  String? _coursesError;
  int? _courseId;

  PlatformFile? _file;
  String? _fileError;

  bool _isPublic = true;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    setState(() {
      _loadingCourses = true;
      _coursesError = null;
    });
    try {
      final list = await CourseApiService.fetchCourses(
        userId: authController.user?.id,
      );
      if (!mounted) return;
      setState(() {
        _courses = list;
        _loadingCourses = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _coursesError = 'دریافت لیست دروس انجام نشد. آیا بک‌اند روشن است؟';
        _loadingCourses = false;
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ApiConfig.allowedFileExtensions,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final f = result.files.first;
    setState(() {
      _file = f;
      _fileError = FileValidator.validate(name: f.name, size: f.size);
    });
  }

  void _snack(String message, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: error ? AppColors.errorBg : null,
        ),
      );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _title.clear();
    _description.clear();
    setState(() {
      _courseId = null;
      _file = null;
      _fileError = null;
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (authController.isDemo || authController.user == null) {
      _snack('در حالت دمو آپلود جزوه ممکن نیست. با شماره دانشجویی وارد شوید.',
          error: true);
      return;
    }

    final formOk = _formKey.currentState!.validate();
    final fileError = FileValidator.validate(name: _file?.name, size: _file?.size);
    setState(() => _fileError = fileError);
    if (!formOk || fileError != null) return;

    setState(() => _uploading = true);
    try {
      await _repo.upload(
        title: _title.text.trim(),
        description: _description.text.trim(),
        courseId: _courseId!,
        isPublic: _isPublic,
        file: _file!,
      );
      if (!mounted) return;
      _resetForm();
      _snack('جزوه با موفقیت آپلود شد.');
    } on ApiException catch (e) {
      if (!mounted) return;
      _snack(e.message, error: true);
    } catch (_) {
      if (!mounted) return;
      _snack('آپلود انجام نشد. دوباره تلاش کنید.', error: true);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiaAppBar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'آپلود جزوه',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'جزوه‌ی خود را برای یکی از دروس بارگذاری کنید.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // عنوان
                    TextFormField(
                      controller: _title,
                      enabled: !_uploading,
                      maxLength: 100,
                      textInputAction: TextInputAction.next,
                      validator: (v) => Validators.required(v, 'عنوان جزوه'),
                      decoration: const InputDecoration(
                        labelText: 'عنوان جزوه',
                        prefixIcon: Icon(Icons.title_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // توضیحات
                    TextFormField(
                      controller: _description,
                      enabled: !_uploading,
                      maxLines: 4,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        labelText: 'توضیحات (اختیاری)',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.notes_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // انتخاب درس
                    _buildCourseField(),
                    const SizedBox(height: 20),

                    // انتخاب فایل
                    _buildFilePicker(),
                    const SizedBox(height: 20),

                    // عمومی / خصوصی
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.outline),
                      ),
                      child: SwitchListTile(
                        value: _isPublic,
                        onChanged:
                            _uploading ? null : (v) => setState(() => _isPublic = v),
                        secondary: Icon(
                          _isPublic ? Icons.public_rounded : Icons.lock_outline_rounded,
                        ),
                        title: Text(_isPublic ? 'عمومی' : 'خصوصی'),
                        subtitle: Text(
                          _isPublic
                              ? 'همه‌ی دانشجوها می‌توانند ببینند و دانلود کنند.'
                              : 'فقط خودتان می‌توانید ببینید و دانلود کنید.',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    SubmitButton(
                      label: 'آپلود جزوه',
                      loading: _uploading,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseField() {
    if (_loadingCourses) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_coursesError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormErrorBanner(message: _coursesError!),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _loadCourses,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('تلاش مجدد'),
          ),
        ],
      );
    }

    // ignore: deprecated_member_use
    return DropdownButtonFormField<int>(
      // ignore: deprecated_member_use
      value: _courseId,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'درس',
        prefixIcon: Icon(Icons.menu_book_outlined),
      ),
      items: [
        for (final c in _courses)
          DropdownMenuItem<int>(
            value: c.id,
            child: Text(c.title, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: _uploading ? null : (v) => setState(() => _courseId = v),
      validator: (v) => v == null ? 'درس را انتخاب کنید.' : null,
    );
  }

  Widget _buildFilePicker() {
    final maxMb = ApiConfig.maxFileBytes ~/ (1024 * 1024);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: _uploading ? null : _pickFile,
          icon: const Icon(Icons.attach_file_rounded),
          label: Text(_file == null ? 'انتخاب فایل' : 'تغییر فایل'),
        ),
        if (_file != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.insert_drive_file_outlined,
                  size: 18, color: AppColors.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${_file!.name} • ${FileValidator.formatSize(_file!.size)}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12.5),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 6),
        Text(
          'فرمت‌های مجاز: PDF، DOCX، ZIP، تصویر • حداکثر ${toPersianDigits(maxMb)} مگابایت',
          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
        ),
        if (_fileError != null) ...[
          const SizedBox(height: 6),
          Text(
            _fileError!,
            style: const TextStyle(fontSize: 12, color: AppColors.error),
          ),
        ],
      ],
    );
  }
}