import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppleAuthService {
  static const String _keyIsLoggedIn = 'isLoggedInWithApple';
  static const String _keyUserId = 'appleUserId';
  static const String _keyUserEmail = 'appleUserEmail';
  static const String _keyUserName = 'appleUserName';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString(_keyUserId),
      'email': prefs.getString(_keyUserEmail),
      'name': prefs.getString(_keyUserName),
    };
  }

  Future<bool> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUserId, credential.userIdentifier ?? '');
      await prefs.setString(_keyUserEmail, credential.email ?? '');
      await prefs.setString(
          _keyUserName,
          '${credential.givenName ?? ''} ${credential.familyName ?? ''}'
              .trim());

      return true;
    } catch (e) {
      print('Error signing in with Apple: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
