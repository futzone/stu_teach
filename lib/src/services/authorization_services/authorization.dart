import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> signIn(String email, String password) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final result = user.user;
      return result != null;
    } catch (e) {
      log("Error: $e");
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      final user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final result = user.user;
      return result != null;
    } catch (e) {
      log("Error: $e");
      return false;
    }
  }

  Stream<User?> getCurrentUser() => _firebaseAuth.authStateChanges();

  User? currentUser() => _firebaseAuth.currentUser;

  Future<void> logout() async {
    _firebaseAuth.signOut();
  }
}
