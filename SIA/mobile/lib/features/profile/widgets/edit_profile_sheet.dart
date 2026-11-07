import 'package:flutter/material.dart';
import '../models/student_profile_model.dart';
import '../services/profile_api_service.dart';

class EditProfileSheet extends StatefulWidget {
  final StudentProfile initialProfile;

  const EditProfileSheet({Key? key, required this.initialProfile}) : super(key: key);

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  final _api = ProfileApiService();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _personalEmailController;
  late TextEditingController _bioController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProfile.fullName);
    _phoneController = TextEditingController(text: widget.initialProfile.phone);
    _personalEmailController = TextEditingController(text: widget.initialProfile.personalEmail);
    _bioController = TextEditingController(text: widget.initialProfile.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _personalEmailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final edited = widget.initialProfile.copyWith(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      personalEmail: _personalEmailController.text.trim(),
      bio: _bioController.text.trim(),
    );

    try {
      final saved = await _api.updateProfile(edited);
      if (!mounted) return;
      Navigator.of(context).pop(saved);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF0C162E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ویرایش مشخصات دانشجویی',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: _isSaving ? null : () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(color: Colors.white12),
                const SizedBox(height: 12),

                // نام
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: _inputDecoration('نام و نام خانوادگی', Icons.person_outline),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'نام نمی‌تواند خالی باشد';
                    if (v.trim().length > 80) return 'حداکثر ۸۰ کاراکتر';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // شماره تماس
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: _inputDecoration('شماره تلفن همراه', Icons.phone_outlined),
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return null;
                    if (!RegExp(r'^09\d{9}$').hasMatch(value)) {
                      return 'شماره موبایل معتبر نیست (مثال: 09121234567)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // ایمیل شخصی
                TextFormField(
                  controller: _personalEmailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: _inputDecoration('ایمیل شخصی (غیردانشگاهی)', Icons.email_outlined),
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return null;
                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                      return 'ایمیل معتبر نیست';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // بیوگرافی
                TextFormField(
                  controller: _bioController,
                  maxLines: 2,
                  maxLength: 500,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: _inputDecoration('درباره من', Icons.info_outline),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D4ED8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text('ذخیره تغییرات', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
      prefixIcon: Icon(icon, color: Colors.blue.shade400, size: 20),
      filled: true,
      fillColor: const Color(0xFF070D1E),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1D4ED8)),
      ),
    );
  }
}