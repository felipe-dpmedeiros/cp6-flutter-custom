import 'package:flutter/material.dart';
import 'package:flutterfirebaseapp/data/settings_repository.dart';
import 'package:flutterfirebaseapp/routes.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      final repo = await SettingsRepository.create();
      final showIntro = await repo.getShowIntro();
      if (showIntro) {
        Navigator.pushReplacementNamed(context, Routes.intro);
      } else {
        Navigator.pushReplacementNamed(context, Routes.home);
      }
    } else {
      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/lock.json',
              width: 250,
              height: 250,
            ),
            const SizedBox(height: 20),
            Text(
              'Gerapass',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Suas senhas seguras em um só lugar.'),
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
