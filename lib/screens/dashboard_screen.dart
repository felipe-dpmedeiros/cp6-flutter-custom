import 'package:flutter/material.dart';
import 'package:flutterfirebaseapp/routes.dart';
import 'package:flutterfirebaseapp/screens/home_screen.dart';
import 'package:flutterfirebaseapp/screens/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = const [
    HomeScreen(),
    SettingsScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Routes.password),
        child: const Icon(Icons.add),
        elevation: 2.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.lock_outline),
              onPressed: () => _onTabTapped(0),
              color: _currentIndex == 0 ? Theme.of(context).colorScheme.primary : Colors.grey,
              tooltip: 'Vault',
            ),
            const SizedBox(width: 40), // The space for the FAB
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => _onTabTapped(1),
              color: _currentIndex == 1 ? Theme.of(context).colorScheme.primary : Colors.grey,
              tooltip: 'Configurações',
            ),
          ],
        ),
      ),
    );
  }
}
