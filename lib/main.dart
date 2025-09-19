import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/map_screen.dart';
import 'screens/chat_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const NVSApp());
}

class NVSApp extends StatelessWidget {
  const NVSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NVS - MeatUp',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/map': (context) => const MapScreen(),
        '/chat': (context) => const ChatScreen(),
      },
    );
  }
}