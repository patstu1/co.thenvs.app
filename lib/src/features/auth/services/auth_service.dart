import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<AppUser> signInWithEmailAndPassword(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    if (credential.user == null) {
      throw Exception('Failed to sign in');
    }
    
    return await getCurrentUser() ?? 
        throw Exception('User data not found');
  }

  Future<AppUser> createUserWithEmailAndPassword(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    if (credential.user == null) {
      throw Exception('Failed to create user');
    }
    
    // Create user document in Firestore
    final user = AppUser(
      id: credential.user!.uid,
      email: email,
      displayName: '',
      bio: '',
      age: 18,
      profileImages: [],
      location: null,
      preferences: UserPreferences(),
      isVerified: false,
      createdAt: DateTime.now(),
      lastSeen: DateTime.now(),
      isOnline: true,
    );
    
    await _firestore.collection('users').doc(user.id).set(user.toMap());
    
    return user;
  }

  Future<void> signOut() async {
    // Update user online status
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'isOnline': false,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }
    
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<AppUser?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;
    
    return AppUser.fromMap(doc.data()!);
  }

  Future<void> updateUserProfile(AppUser user) async {
    await _firestore.collection('users').doc(user.id).update(user.toMap());
  }

  Future<void> updateLastSeen() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'lastSeen': FieldValue.serverTimestamp(),
        'isOnline': true,
      });
    }
  }
}