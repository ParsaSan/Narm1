import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// لوگوی موقت. وقتی فایل لوگوی اصلی را دارید:
/// ۱. آن را در assets/images/logo.png بگذارید و در pubspec.yaml زیر flutter: assets: اضافه کنید.
/// ۲. child این ویجت را با Image.asset('assets/images/logo.png') عوض کنید.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'لوگوی SIA',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.logoBg,
          borderRadius: BorderRadius.circular(size * 0.27),
          border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_rounded, size: size * 0.46, color: AppColors.logoGold),
            Text(
              'SIA',
              style: TextStyle(
                fontSize: size * 0.16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
