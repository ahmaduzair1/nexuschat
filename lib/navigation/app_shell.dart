import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../widgets/animated_nav_bar.dart';
import '../screens/chat_list/chat_list_screen.dart';
import '../screens/status/status_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ChatListScreen(),
    const StatusScreen(),
    const _PlaceholderScreen(title: 'AI Assistant', icon: Icons.auto_awesome_rounded),
    const SettingsScreen(),
  ];

  void _onNavTap(int index) {
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyBackground,
      body: Stack(
        children: [
          // Content with smooth crossfade
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: KeyedSubtree(
              key: ValueKey(_currentIndex),
              child: _pages[_currentIndex],
            ),
          ),
          
          // Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedNavBar(
              currentIndex: _currentIndex,
              onTap: _onNavTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.goldSubtle),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.silverText),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon in v2',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.silverMuted),
          ),
        ],
      ),
    );
  }
}
