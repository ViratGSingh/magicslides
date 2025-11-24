import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoginLoading = false;
  bool _isSignupLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoginLoading => _isLoginLoading;
  bool get isSignupLoading => _isSignupLoading;
  String? get errorMessage => _errorMessage;

  // Sign up
  Future<bool> signUp(String email, String password, String displayName) async {
    _setSignupLoading(true);
    try {
      _user = await _authService.signUp(email, password, displayName);
      _errorMessage = null;
      return _user != null;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred.';
      return false;
    } finally {
      _setSignupLoading(false);
    }
  }

  // Sign in
  Future<bool> signIn(String email, String password) async {
    _setLoginLoading(true);
    try {
      _user = await _authService.signIn(email, password);
      _errorMessage = null;
      return _user != null;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred.';
      return false;
    } finally {
      _setLoginLoading(false);
    }
  }

  // Reset Password
  Future<bool> resetPassword(String email) async {
    _setLoginLoading(true); // Reuse login loading state or add a new one
    try {
      await _authService.resetPassword(email);
      _errorMessage = null;
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred.';
      return false;
    } finally {
      _setLoginLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  // Check current user status
  void checkCurrentUser() {
    _user = _authService.getCurrentUser();
    notifyListeners();
  }

  void _setLoginLoading(bool value) {
    _isLoginLoading = value;
    notifyListeners();
  }

  void _setSignupLoading(bool value) {
    _isSignupLoading = value;
    notifyListeners();
  }

  void resetLoginState() {
    _isLoginLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  void resetSignupState() {
    _isSignupLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
