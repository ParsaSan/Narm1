import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../features/auth/state/auth_controller.dart';

/// هدر مشترک اپ: «SIA | دستیار هوشمند دانشجویی» + برچسب اسپرینت.
/// هر صفحه‌ای که بخواهد هدر یکسان داشته باشد، کافی است بنویسد:
///   appBar: const SiaAppBar(),
class SiaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SiaAppBar({super.key, this.sprintLabel = '', this.actions});

  final String sprintLabel;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: ListenableBuilder(
        listenable: authController,
        builder: (context, _) {
          final name = authController.user?.fullName ?? '';
          return Row(
            children: [
              const Flexible(
                child: Text(
                  'SIA | دستیار هوشمند دانشجویی',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (name.isNotEmpty) ...[
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
      actions: [
        ...?actions,
        IconButton(
          tooltip: 'خروج',
          icon: const Icon(Icons.logout_rounded),
          onPressed: () {
            authController.logout();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.welcome, (_) => false);
          },
        ),
      ],
    );
  }
}

/*class SprintBadge extends StatelessWidget {
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
}*/
