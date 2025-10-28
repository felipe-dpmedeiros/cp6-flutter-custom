import 'package:flutter/material.dart';
import 'package:flutterfirebaseapp/core/auth_guard.dart';
import 'package:flutterfirebaseapp/screens/NewPasswordScreen.dart';
import 'package:flutterfirebaseapp/screens/settings_screen.dart';
import 'package:flutterfirebaseapp/screens/intro/intro_screen.dart';
import 'package:flutterfirebaseapp/screens/splash/splash_screen.dart';
import 'package:flutterfirebaseapp/screens/dashboard_screen.dart';

class Routes {
  static const String splash = '/';
  static const String intro = '/intro';
  static const String home = '/home';
  static const String password = '/password';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name == splash) {
      return MaterialPageRoute(builder: (_) => SplashScreen());
    } else if (settings.name == intro) {
      return MaterialPageRoute(builder: (_) => IntroScreen());
    } else if (settings.name == home) {
      // AuthGuard now wraps the Dashboard (bottom‑nav) screen
      return MaterialPageRoute(
        builder: (_) => AuthGuard(child: DashboardScreen()),
      );
    } else if (settings.name == password) {
      return MaterialPageRoute(builder: (_) => NewPasswordScreen());
    } else if (settings.name == settings) {
      return MaterialPageRoute(builder: (_) => SettingsScreen());
    } else {
      return MaterialPageRoute(
        builder: (_) =>
            Scaffold(body: Center(child: Text('Rota não encontrada!'))),
      );
    }
  }
}
