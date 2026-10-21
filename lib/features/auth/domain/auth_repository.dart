/// Contract for authentication, independent of any backend.
///
/// The presentation layer depends only on this interface; the concrete
/// implementation (a fake for now, Supabase later) is bound via a provider.
/// Swapping backends therefore touches one binding, not the screens.
abstract interface class AuthRepository {
  /// Signs an existing user in with email + password.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  /// Registers a new user.
  ///
  /// Returns `true` when the backend requires email confirmation (no session is
  /// created yet — the user must tap the link we email them before they can sign
  /// in); `false` when a session is created immediately (confirmation disabled).
  Future<bool> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  /// Re-sends the sign-up confirmation link to [email].
  Future<void> resendConfirmation(String email);

  /// Sends a password-reset code/link to [email].
  Future<void> sendPasswordReset(String email);

  /// Completes a password reset using the 6-digit [token] emailed to [email],
  /// then sets [newPassword]. The recovery token is verified first.
  Future<void> resetPasswordWithToken({
    required String email,
    required String token,
    required String newPassword,
  });

  /// Whether the signed-in account actually has an email+password login.
  ///
  /// False for an account created purely through Google or Apple: there is no
  /// password on it, so there is nothing to re-verify and nothing the user
  /// could possibly type as their "current password". Callers use this to
  /// offer *setting* a first password instead of changing an existing one.
  Future<bool> hasPasswordLogin();

  /// Changes the signed-in user's password.
  ///
  /// [currentPassword] is re-verified first (so a stolen, unlocked session
  /// can't silently change the password); [newPassword] then replaces it.
  /// Pass a null [currentPassword] only when [hasPasswordLogin] is false —
  /// the account is OAuth-only and is setting its first password.
  Future<void> changePassword({
    required String? currentPassword,
    required String newPassword,
  });

  /// Verifies the current session is still valid.
  Future<void> verifySession();

  /// Ends the current session.
  Future<void> signOut();

  /// Permanently deletes the signed-in user's account, then ends the session.
  /// Implemented server-side (a client can't delete its own auth user).
  Future<void> deleteAccount();

  /// OAuth sign-in — not wired yet (UI only in this phase).
  Future<void> signInWithGoogle();

  /// OAuth sign-in — not wired yet (UI only in this phase).
  Future<void> signInWithApple();
}
