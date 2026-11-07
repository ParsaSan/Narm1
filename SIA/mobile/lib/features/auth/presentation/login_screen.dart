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
import '../state/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentNumber = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  bool _prefilled = false;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // اگر از صفحه‌ی ثبت‌نام آمده‌ایم، شماره دانشجویی از قبل پر می‌شود.
    if (_prefilled) return;
    _prefilled = true;
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String) _studentNumber.text = arg;
  }

  @override
  void dispose() {
    _studentNumber.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await authController.login(
        identifier: toEnglishDigits(_studentNumber.text.trim()),
        password: _password.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'ورود انجام نشد. دوباره تلاش کنید.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ورود با شناسه دانشجویی')),
      body: CenteredFormBody(
        children: [
          const SizedBox(height: 8),
          const Text(
            'شماره دانشجویی و رمز عبور خود را وارد کنید.',
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
                  PasswordField(
                    controller: _password,
                    validator: (v) => Validators.password(v, checkLength: false),
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
          SubmitButton(label: 'ورود به حساب', loading: _loading, onPressed: _submit),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('حساب ندارید؟', style: TextStyle(color: AppColors.textSecondary)),
              TextButton(
                onPressed: _loading
                    ? null
                    : () => Navigator.of(context).pushReplacementNamed(AppRoutes.register),
                child: const Text('ثبت‌نام کنید'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
