import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'dart:io';
import '../models/user_model.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign up with email, password, and display name
  Future<UserModel?> signUp(
      String email, String password, String displayName) async {
    print('AuthService: Attempting signup for $email');
    try {
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': displayName},
      ).timeout(const Duration(seconds: 30));

      print('AuthService: Signup call completed. User: ${res.user?.email}');

      final User? user = res.user;
      final Session? session = res.session;

      if (user != null) {
        if (session == null) {
          // User created but no session (likely email verification required)
          print(
              'AuthService: User created but no session. Email verification might be required.');
          // Proceeding as requested by user, even if session is null.
        }
        return UserModel(
          id: user.id,
          email: user.email ?? '',
          displayName: user.userMetadata?['full_name'] as String?,
        );
      }
      throw AuthException('Signup failed: Server returned null user.');
    } on AuthException {
      // Re-throw custom AuthExceptions
      rethrow;
    } on AuthApiException catch (e) {
      print(
          'AuthService: Supabase Auth API Error: ${e.message}, Status: ${e.statusCode}');
      throw _handleSupabaseError(e);
    } on TimeoutException catch (_) {
      print('AuthService: Signup timed out.');
      throw AuthException(
          'Connection timed out. Please check your internet connection.');
    } on SocketException catch (_) {
      print('AuthService: Network error.');
      throw AuthException('No internet connection. Please check your network.');
    } catch (e) {
      print('AuthService: Unexpected signup error: $e');
      throw AuthException('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Sign in with email and password
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final AuthResponse res = await _supabase.auth
          .signInWithPassword(
            email: email,
            password: password,
          )
          .timeout(const Duration(seconds: 30));

      final User? user = res.user;
      if (user != null) {
        return UserModel(
          id: user.id,
          email: user.email ?? '',
          displayName: user.userMetadata?['full_name'] as String?,
        );
      }
      throw AuthException('Login failed: Server returned null user.');
    } on AuthApiException catch (e) {
      print(
          'AuthService: Supabase Auth API Error: ${e.message}, Status: ${e.statusCode}');
      throw _handleSupabaseError(e);
    } on TimeoutException catch (_) {
      throw AuthException(
          'Connection timed out. Please check your internet connection.');
    } on SocketException catch (_) {
      throw AuthException('No internet connection. Please check your network.');
    } catch (e) {
      print('AuthService: Unexpected login error: $e');
      throw AuthException('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthApiException catch (e) {
      throw _handleSupabaseError(e);
    } on SocketException catch (_) {
      throw AuthException('No internet connection. Please check your network.');
    } catch (e) {
      throw AuthException('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      // Fail silently on signout or log it
      print('AuthService: Signout error: $e');
    }
  }

  // Get current user
  UserModel? getCurrentUser() {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      return UserModel(
        id: user.id,
        email: user.email ?? '',
        displayName: user.userMetadata?['full_name'] as String?,
      );
    }
    return null;
  }

  AuthException _handleSupabaseError(AuthApiException e) {
    final msg = e.message.toLowerCase();
    final statusCode = int.tryParse(e.statusCode ?? '0') ?? 0;

    if (msg.contains('invalid login credentials') ||
        msg.contains('invalid_grant')) {
      return AuthException('Invalid email or password.');
    } else if (msg.contains('email not confirmed')) {
      return AuthException('Email not confirmed. Please check your inbox.');
    } else if (msg.contains('rate limit exceeded') || statusCode == 429) {
      return AuthException('Too many attempts. Please try again later.');
    } else if (msg.contains('user already registered')) {
      return AuthException(
          'This email is already registered. Please login instead.');
    } else if (statusCode >= 500) {
      return AuthException('Server error. Please try again later.');
    }
    return AuthException(e.message);
  }
}
