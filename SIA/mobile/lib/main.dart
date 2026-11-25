import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_routes.dart';
import 'core/network/auth_http_client.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/welcome_screen.dart';
import 'features/auth/state/auth_controller.dart';
import 'shared/layout/main_layout.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await authController.restoreSession();

  // اگر سرور 401 داد: خروج و برگشت به صفحه‌ی خوش‌آمد
  AuthHttpClient.onUnauthorized = () {
    authController.logout();
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(AppRoutes.welcome, (_) => false);
  };

  runApp(const SiamApp());
}

class SiamApp extends StatelessWidget {
  const SiamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سامانه دانشگاهی SIA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [Locale('fa', 'IR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute:
          authController.isLoggedIn ? AppRoutes.home : AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (_) => const WelcomeScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.home: (_) => const MainLayout(),
      },
    );
  }
}