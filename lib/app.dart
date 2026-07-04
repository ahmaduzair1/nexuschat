import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/providers/auth_provider.dart';
import 'navigation/app_shell.dart';
import 'screens/auth/login_screen.dart';

/// Nexus Chat — App Entry Point
class NexusApp extends ConsumerWidget {
  const NexusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lock to portrait for the concept app
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFF0A0E1A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Nexus Chat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: authState.when(
        data: (user) {
          if (user != null) return const AppShell();
          return const LoginScreen();
        },
        loading: () => const Scaffold(
          backgroundColor: Color(0xFF0A0E1A),
          body: Center(child: CircularProgressIndicator(color: Color(0xFF00C896))),
        ),
        error: (e, trace) => Scaffold(
          body: Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
