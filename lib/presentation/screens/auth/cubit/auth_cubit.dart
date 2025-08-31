import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:stockmate/data/datasources/local/shared_pref.dart';

import '../../../../domain/entities/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  bool isLoginPage = true;
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void changeScreen() {
    isLoginPage = !isLoginPage;
    userNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    emit(AuthInitial());
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegExp.hasMatch(email);
  }

  Future<void> signUp() async {
    final userName = userNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (userName.isEmpty) {
      emit(AuthError(message: "Please enter a user name."));
      return;
    }
    if (email.isEmpty) {
      emit(AuthError(message: "Please enter an email address."));
      return;
    }
    if (!_isValidEmail(email)) {
      emit(AuthError(message: "Please enter a valid email address."));
      return;
    }
    if (password.isEmpty) {
      emit(AuthError(message: "Please enter a password."));
      return;
    }
    if (password.length < 6) {
      emit(AuthError(message: "Password must be at least 6 characters long."));
      return;
    }
    if (password != confirmPassword) {
      emit(AuthError(message: "Passwords do not match."));
      return;
    }
    emit(AuthLoading());
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _auth.currentUser?.updateDisplayName(userName);

      final user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set({
          "uid": user.uid,
          "name": userName,
          "email": user.email,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      emit(AuthSuccess(user: _auth.currentUser));
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred. Please try again.';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      }
      emit(AuthError(message: message));
    }
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      emit(AuthError(message: "Please enter your email address."));
      return;
    }
    if (password.isEmpty) {
      emit(AuthError(message: "Please enter your password."));
      return;
    }

    emit(AuthLoading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        final idToken = await user.getIdToken();

        final userModel = UserModel(
          name: user.displayName ?? "",
          email: user.email ?? "",
          idToken: idToken!,
        );
        final userData = UserService();

        await userData.saveUser(userModel);
        await userData.printUser();
      }

      emit(AuthSuccess(user: _auth.currentUser));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: "Invalid email or password. Please try again."));
    }
  }
}
