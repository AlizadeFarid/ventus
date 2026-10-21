import '../domain/auth_exception.dart';
import '../domain/auth_repository.dart';

/// Temporary in-memory [AuthRepository] used until Supabase is wired up.
///
/// Simulates network latency and a couple of realistic failures so the screens,
/// loading states and error handling can be built and tested end-to-end. It
/// will be replaced by a `SupabaseAuthRepository` with no changes to the UI.
class FakeAuthRepository implements AuthRepository {
  static const _delay = Duration(milliseconds: 800);

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_delay);
    if (password == 'wrong') {
      throw const AuthException(AuthErrorCode.invalidCredentials);
    }
  }

  @override
  Future<bool> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_delay);
    if (email == 'taken@ventus.app') {
      throw const AuthException(AuthErrorCode.emailAlreadyExists);
    }
    // Simulate "Confirm email" ON for any address containing "verify" so the
    // verify-email flow can be exercised without a real backend.
    return email.contains('verify');
  }

  @override
  Future<void> resendConfirmation(String email) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> resetPasswordWithToken({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    await Future<void>.delayed(_delay);
    // In dev, accept "123456" as the valid recovery code.
    if (token != '123456') {
      throw const AuthException(AuthErrorCode.invalidOtp);
    }
  }

  @override
  Future<bool> hasPasswordLogin() async => true;

  @override
  Future<void> changePassword({
    required String? currentPassword,
    required String newPassword,
  }) async {
    await Future<void>.delayed(_delay);
    if (currentPassword == 'wrong') {
      throw const AuthException(AuthErrorCode.invalidCredentials);
    }
  }

  @override
  Future<void> verifySession() async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> deleteAccount() async {}

  @override
  Future<void> signInWithGoogle() async {
    throw const AuthException(AuthErrorCode.googleComingSoon);
  }

  @override
  Future<void> signInWithApple() async {
    throw const AuthException(AuthErrorCode.appleComingSoon);
  }
}
