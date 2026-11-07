import 'package:flutter/material.dart';

import '../../../core/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/centered_form_body.dart';
import '../../../shared/widgets/info_banner.dart';
import '../state/auth_controller.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _enterDemo(BuildContext context) {
    authController.loginAsDemo();
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CenteredFormBody(
        children: [
          const SizedBox(height: 32),
          const Center(child: AppLogo()),
          const SizedBox(height: 20),
          const Text(
            'SIA | دستیار دانشجویی',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Student Intelligent Assistant',
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 13, color: AppColors.accent, letterSpacing: 0.3),
          ),
          const SizedBox(height: 14),
          const Text(
            'پلتفرم یکپارچه مدیریت دروس، منابع آموزشی، تکالیف و امتحانات کلاسی — '
            'طراحی‌شده توسط تیم دانشجویی در قالب متدولوژی چابک.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.5, height: 1.9, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          const InfoBanner(
            text: 'پروتوتایپ رسمی اسپرینت ۱: احراز هویت آزمایشی، مشاهده دروس، '
                'پیش‌نمایش منابع و تکالیف و ویرایش محلی پروفایل تحصیلی.',
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _enterDemo(context),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryDeep,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.bolt_rounded),
            label: const Text('ورود مستقیم نسخه دمو (پیشنهاد به داوران)'),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              foregroundColor: AppColors.onPrimaryLight,
            ),
            icon: const Icon(Icons.login_rounded),
            label: const Text('ورود با شناسه دانشجویی'),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.register),
            icon: const Icon(Icons.person_add_alt_1_rounded),
            label: const Text('ثبت‌نام دانشجویی جدید'),
          ),
          const SizedBox(height: 36),
          const _TeamCard(),
        ],
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.teamBg,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.groups_rounded, color: AppColors.teamIcon),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'پروژه مهندسی نرم‌افزار — اسپرینت ۱ از ۴',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  'توسعه‌داده‌شده توسط تیم ۴ نفره دانشجویی',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
