import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class AuthService {
  final storage = const FlutterSecureStorage();
  static const String USER_KEY = 'user_auth';

  Future<bool> isUserLoggedIn() async {
    final userJson = await storage.read(key: USER_KEY);
    return userJson != null;
  }

  Future<void> saveUserAuth(AuthResult result) async {
    final userJson = json.encode({
      'userIdentifier': result.userIdentifier,
      'email': result.email,
      'fullName': result.fullName,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await storage.write(key: USER_KEY, value: userJson);
  }

  Future<void> logout() async {
    await storage.delete(key: USER_KEY);
  }

  String generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<AuthResult> signInWithApple() async {
    try {
      if (await isUserLoggedIn()) {
        return AuthResult(success: true);
      }

      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final result = AuthResult(
        success: true,
        email: appleCredential.email,
        fullName: '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim(),
        userIdentifier: appleCredential.userIdentifier,
      );

      await saveUserAuth(result);
      return result;

    } catch (e) {
      return AuthResult(
        success: false,
        error: e.toString(),
      );
    }
  }
}

class AuthResult {
  final bool success;
  final String? email;
  final String? fullName;
  final String? userIdentifier;
  final String? error;

  AuthResult({
    required this.success,
    this.email,
    this.fullName,
    this.userIdentifier,
    this.error,
  });
} 