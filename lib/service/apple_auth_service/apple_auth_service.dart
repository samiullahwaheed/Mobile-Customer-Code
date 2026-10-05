import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// What the backend needs from Sign in with Apple.
class AppleAuthResult {
  final String identityToken;
  final String rawNonce;
  final String authorizationCode;
  // Apple sends the name only on the first sign-in
  final String? firstName;
  final String? lastName;

  AppleAuthResult({
    required this.identityToken,
    required this.rawNonce,
    required this.authorizationCode,
    this.firstName,
    this.lastName,
  });
}

class AppleAuthService {
  /// Shows the Apple sheet. Returns null when the user cancels; throws on
  /// other failures.
  Future<AppleAuthResult?> signIn() async {
    // Apple gets sha256(rawNonce); the backend checks it against rawNonce
    final rawNonce = _generateNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final identityToken = credential.identityToken;
      if (identityToken == null || identityToken.isEmpty) {
        throw Exception("Apple did not return an identity token");
      }

      log("========== APPLE SIGN IN SUCCESS ==========");

      return AppleAuthResult(
        identityToken: identityToken,
        rawNonce: rawNonce,
        authorizationCode: credential.authorizationCode,
        firstName: credential.givenName,
        lastName: credential.familyName,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) return null;
      rethrow;
    }
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }
}
