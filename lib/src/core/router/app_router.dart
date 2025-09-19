import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/profile_setup_screen.dart';
import '../../features/profile/screens/profile_grid_screen.dart';
import '../../features/map/screens/live_map_screen.dart';
import '../../features/chat/screens/chat_rooms_screen.dart';
import '../../features/matchmaking/screens/matches_screen.dart';
import '../widgets/main_navigation.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/profile-setup';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }
      return null;
    },
    routes: [
      // Authentication routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      
      // Main app shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const ProfileGridScreen(),
          ),
          GoRoute(
            path: '/map',
            builder: (context, state) => const LiveMapScreen(),
          ),
          GoRoute(
            path: '/matches',
            builder: (context, state) => const MatchesScreen(),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => const ChatRoomsScreen(),
          ),
        ],
      ),
    ],
  );
});