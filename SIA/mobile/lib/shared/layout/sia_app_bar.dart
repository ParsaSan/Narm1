import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// هدر مشترک اپ: «SIA | دستیار هوشمند دانشجویی» + برچسب اسپرینت.
/// هر صفحه‌ای که بخواهد هدر یکسان داشته باشد، کافی است بنویسد:
///   appBar: const SiaAppBar(),
class SiaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SiaAppBar({super.key, this.sprintLabel = 'اسپرینت ۱', this.actions});

  final String sprintLabel;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: actions,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Flexible(
            child: Text(
              'SIA | دستیار هوشمند دانشجویی',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          SprintBadge(label: sprintLabel),
        ],
      ),
    );
  }
}

class SprintBadge extends StatelessWidget {
  const SprintBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.badgeBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.badgeText,
        ),
      ),
    );
  }
}
