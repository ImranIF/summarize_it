import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:summarize_it/components/sessionmanager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Email/Password Sign In
  Future<AuthResponse?> signInWithEmailPassword(
      String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        SessionManager.logIn();
        return response;
      }
      return null;
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  // Email/Password Sign Up
  Future<AuthResponse?> signUpWithEmailPassword(
      String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    }
  }

  // Google Sign In Latest Implementation
  Future<AuthResponse?> signInWithGoogle() async {
    const webClientId =
        "900022792240-o2r6b1sf0kluov7jntd5mqc5dj45f2cu.apps.googleusercontent.com";
    final googleSignIn = GoogleSignIn.instance;
    final scopes = ['email'];
    await googleSignIn.initialize(
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.attemptLightweightAuthentication();

    if (googleUser == null) {
      throw AuthException("Failed to sign in with Google");
    }

    final authorization =
        await googleUser.authorizationClient.authorizationForScopes(scopes) ??
            await googleUser.authorizationClient.authorizeScopes(scopes);

    final idToken = googleUser.authentication.idToken;

    if (idToken == null) {
      throw AuthException("Failed to retrieve Google ID token");
    }

    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );

    if (response.user != null) {
      await _ensureUserProfile(response.user!); // Ensure user profile exists
      SessionManager.logIn();
      return response;
    }
    return null;
  }
  // // Google Sign In
  // Future<AuthResponse?> signInWithGoogle() async {
  //   try {
  //     // Configure Google Sign In with explicit configuration
  //     final GoogleSignIn googleSignIn = GoogleSignIn(
  //       scopes: ['email', 'profile'],
  //     );

  //     // Clear any previous sign-in
  //     await googleSignIn.signOut();

  //     print('🚀 Starting Google Sign-in...');

  //     // Begin interactive sign-in process
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //     if (googleUser == null) {
  //       print('Google Sign-in cancelled by user');
  //       return null;
  //     }

  //     print('Google User signed in: ${googleUser.email}');

  //     // Authenticate with Google
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     print('Google Auth Debug:');
  //     print(
  //         'Access Token: ${googleAuth.accessToken != null ? 'Present (${googleAuth.accessToken!.substring(0, 20)}...)' : 'Missing'}');
  //     print(
  //         'ID Token: ${googleAuth.idToken != null ? 'Present (${googleAuth.idToken!.substring(0, 20)}...)' : 'Missing'}');

  //     if (googleAuth.accessToken == null || googleAuth.idToken == null) {
  //       throw Exception(
  //           'Failed to get Google authentication tokens - Access: ${googleAuth.accessToken != null}, ID: ${googleAuth.idToken != null}');
  //     }

  //     print('Attempting to sign in with Supabase...');

  //     // Sign in with Supabase using Google credentials
  //     final response = await _supabase.auth.signInWithIdToken(
  //       provider: OAuthProvider.google,
  //       idToken: googleAuth.idToken!,
  //       accessToken: googleAuth.accessToken!,
  //     );

  //     print(
  //         ' Supabase response: ${response.user != null ? 'Success ✅' : 'Failed ❌'}');

  //     if (response.user != null) {
  //       print('👤 User authenticated: ${response.user!.email}');
  //       // Check if user profile exists in users table, create if not
  //       await _ensureUserProfile(response.user!);
  //       SessionManager.logIn();
  //       return response;
  //     }
  //     return null;
  //   } catch (e) {
  //     print('Google sign in error: $e');
  //     print(' Error type: ${e.runtimeType}');
  //     print(' Full error: ${e.toString()}');

  //     // Provide specific error messages based on common issues
  //     if (e.toString().toLowerCase().contains('oauth') ||
  //         e.toString().toLowerCase().contains('provider') ||
  //         e.toString().toLowerCase().contains('unauthorized')) {
  //       throw Exception(
  //           'Google OAuth configuration issue in Supabase. Check provider settings and redirect URLs.');
  //     } else if (e.toString().toLowerCase().contains('network') ||
  //         e.toString().toLowerCase().contains('connection')) {
  //       throw Exception('Network error. Check internet connection.');
  //     } else if (e.toString().toLowerCase().contains('token')) {
  //       throw Exception(
  //           'Token validation failed. Check Google OAuth setup in Supabase.');
  //     } else if (e.toString().toLowerCase().contains('redirect')) {
  //       throw Exception(
  //           'Redirect URL mismatch. Verify redirect URLs in both Google and Supabase.');
  //     }
  //     rethrow;
  //   }
  // }

  // Facebook Sign In
  Future<AuthResponse?> signInWithFacebook(BuildContext context) async {
    try {
      await FacebookAuth.instance.logOut();

      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status != LoginStatus.success ||
          loginResult.accessToken == null) {
        throw Exception('Facebook login failed');
      }

      // Sign in with Supabase using Facebook credentials
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.facebook,
        idToken: loginResult.accessToken!.tokenString,
      );

      if (response.user != null) {
        // Check if user profile exists in users table, create if not
        await _ensureUserProfile(response.user!);
        SessionManager.logIn();
        return response;
      }
      return null;
    } catch (e) {
      print('Facebook sign in error: $e');
      if (e.toString().contains('account-exists-with-different-credential')) {
        showDialog(
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Account exists with different credential'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              )
            ],
          ),
          context: context,
        );
      }
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      await GoogleSignIn.instance.signOut();
      await FacebookAuth.instance.logOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Get Current User
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _supabase.auth.currentUser != null;
  }

  // Listen to auth state changes
  Stream<AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }

  // Ensure user profile exists in users table
  Future<void> _ensureUserProfile(User user) async {
    try {
      final existingUser = await _supabase
          .from('users')
          .select()
          .eq('email', user.email!)
          .maybeSingle();

      if (existingUser == null) {
        await _supabase.from('users').insert({
          'id': user.id,
          'fullName': user.userMetadata?['full_name'] ??
              user.email?.split('@')[0] ??
              'User',
          'userName': user.userMetadata?['user_name'] ??
              user.email?.split('@')[0] ??
              'User',
          'email': user.email!,
          'address': '',
          'dateOfBirth': DateTime.now().toIso8601String(),
          'password': '',
          'imageURL': user.userMetadata?['avatar_url'] ?? '',
          'postCount': 0,
        });
      }
    } catch (e) {
      print('Error ensuring user profile: $e');
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      print('Reset password error: $e');
      rethrow;
    }
  }
}
