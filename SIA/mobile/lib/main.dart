import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/auth/presentation/welcome_screen.dart';
import 'shared/layout/main_layout.dart';

void main() {
  runApp(const SiamApp());
}

class SiamApp extends StatelessWidget {
  const SiamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سامانه دانشگاهی SIA',
      debugShowCheckedModeBanner: false,

      // تم تیره + فونت وزیرمتن برای کل اپ (رنگ‌ها همان رنگ‌های قبلی تیم است)
      theme: AppTheme.dark,

      // زبان فارسی: کل اپ خودکار راست‌به‌چپ (RTL) می‌شود
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [Locale('fa', 'IR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // اول صفحه‌ی خوش‌آمد؛ بعد از ورود، صفحه‌ی اصلی با منوی پایین
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (_) => const WelcomeScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.home: (_) => const MainLayout(),
      },
    );
  }
}
