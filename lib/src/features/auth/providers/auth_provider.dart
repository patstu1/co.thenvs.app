import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) async {
      if (user == null) return null;
      final authService = ref.watch(authServiceProvider);
      return await authService.getCurrentUser();
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authServiceProvider));
});

class AuthController extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthController(this._authService) : super(const AuthState.initial());

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _authService.signInWithEmailAndPassword(email, password);
      state = AuthState.authenticated(user);
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_getAuthErrorMessage(e));
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _authService.createUserWithEmailAndPassword(email, password);
      state = AuthState.authenticated(user);
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_getAuthErrorMessage(e));
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = const AuthState.initial();
  }

  Future<void> resetPassword(String email) async {
    state = const AuthState.loading();
    try {
      await _authService.resetPassword(email);
      state = const AuthState.passwordResetSent();
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_getAuthErrorMessage(e));
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

abstract class AuthState {
  const AuthState();
  
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(AppUser user) = _Authenticated;
  const factory AuthState.error(String message) = _Error;
  const factory AuthState.passwordResetSent() = _PasswordResetSent;
}

class _Initial extends AuthState {
  const _Initial();
}

class _Loading extends AuthState {
  const _Loading();
}

class _Authenticated extends AuthState {
  const _Authenticated(this.user);
  final AppUser user;
}

class _Error extends AuthState {
  const _Error(this.message);
  final String message;
}

class _PasswordResetSent extends AuthState {
  const _PasswordResetSent();
}