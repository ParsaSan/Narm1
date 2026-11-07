import 'package:flutter/material.dart';

import '../../../core/app_routes.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/persian_digits.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/centered_form_body.dart';
import '../../../shared/widgets/form_error_banner.dart';
import '../../../shared/widgets/password_field.dart';
import '../../../shared/widgets/submit_button.dart';
import '../data/auth_models.dart';
import '../state/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _studentNumber = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_firstName, _lastName, _studentNumber, _phone, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    final studentNumber = toEnglishDigits(_studentNumber.text.trim());
    final password = _password.text;
    setState(() => _loading = true);

    // ۱. ثبت‌نام
    try {
      await authController.register(RegisterRequest(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        studentNumber: studentNumber,
        phoneNumber: toEnglishDigits(_phone.text.trim()),
        password: password,
      ));
    } on ApiException catch (e) {
      if (mounted) setState(() {
        _error = e.message;
        _loading = false;
      });
      return;
    } catch (_) {
      if (mounted) setState(() {
        _error = 'ثبت‌نام انجام نشد. دوباره تلاش کنید.';
        _loading = false;
      });
      return;
    }

    // ۲. ورود خودکار با همان اطلاعات
    try {
      await authController.login(identifier: studentNumber, password: password);
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
    } catch (_) {
      // ثبت‌نام موفق بوده؛ فقط ورود خودکار نشد. کاربر خودش وارد می‌شود.
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ثبت‌نام انجام شد. حالا وارد حساب خود شوید.')),
      );
      Navigator.of(context).pushReplacementNamed(AppRoutes.login, arguments: studentNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ثبت‌نام دانشجویی جدید')),
      body: CenteredFormBody(
        children: [
          const SizedBox(height: 8),
          const Text(
            'اطلاعات خود را وارد کنید. شماره موبایل اختیاری است.',
            style: TextStyle(fontSize: 14, height: 1.8, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _firstName,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.givenName],
                    validator: (v) => Validators.required(v, 'نام'),
                    decoration: const InputDecoration(
                      labelText: 'نام',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastName,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.familyName],
                    validator: (v) => Validators.required(v, 'نام خانوادگی'),
                    decoration: const InputDecoration(
                      labelText: 'نام خانوادگی',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _studentNumber,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.right,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    validator: Validators.studentNumber,
                    decoration: const InputDecoration(
                      labelText: 'شماره دانشجویی',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.right,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    validator: Validators.optionalPhone,
                    decoration: const InputDecoration(
                      labelText: 'شماره موبایل (اختیاری)',
                      hintText: '09123456789',
                      prefixIcon: Icon(Icons.phone_iphone_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PasswordField(
                    controller: _password,
                    helperText: 'حداقل ۸ کاراکتر',
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 16),
                  PasswordField(
                    controller: _confirm,
                    label: 'تکرار رمز عبور',
                    autofillHints: const [AutofillHints.newPassword],
                    validator: (v) => Validators.confirmPassword(v, _password.text),
                    onSubmitted: (_) => _submit(),
                  ),
                ],
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            FormErrorBanner(message: _error!),
          ],
          const SizedBox(height: 24),
          SubmitButton(label: 'ثبت‌نام', loading: _loading, onPressed: _submit),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('قبلاً ثبت‌نام کرده‌اید؟', style: TextStyle(color: AppColors.textSecondary)),
              TextButton(
                onPressed: _loading
                    ? null
                    : () => Navigator.of(context).pushReplacementNamed(AppRoutes.login),
                child: const Text('وارد شوید'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
