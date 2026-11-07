import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// کادر اطلاع‌رسانی روشن با آیکون «i» که در صفحه‌ی ورود و داشبورد تکرار شده.
class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.infoIcon,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline_rounded, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.infoText,
                fontSize: 12.5,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
