import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserCredential> signUp(String email, String password);
  Future<void> updateUserDisplayName(String name);
  Future<UserCredential> login(String email, String password);
  User? getCurrentUser();
}