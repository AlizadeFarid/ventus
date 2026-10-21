import '../../../l10n/app_localizations.dart';
import '../domain/auth_exception.dart';

/// Maps an [AuthErrorCode] to a localized, user-facing message.
extension AuthErrorL10n on AuthErrorCode {
  String message(AppLocalizations l10n) => switch (this) {
    AuthErrorCode.invalidCredentials => l10n.authInvalidCredentials,
    AuthErrorCode.emailAlreadyExists => l10n.authEmailExists,
    AuthErrorCode.emailNotConfirmed => l10n.authEmailNotConfirmed,
    AuthErrorCode.googleComingSoon => l10n.providerComingSoon('Google'),
    AuthErrorCode.appleComingSoon => l10n.providerComingSoon('Apple'),
    AuthErrorCode.weakPassword => l10n.authWeakPassword,
    AuthErrorCode.samePassword => l10n.authSamePassword,
    AuthErrorCode.invalidOtp => l10n.authInvalidOtp,
    AuthErrorCode.rateLimitExceeded => l10n.authRateLimited,
    // Never surfaced (the controller swallows cancellations), but the
    // switch must stay exhaustive.
    AuthErrorCode.cancelled => '',
    AuthErrorCode.unknown => l10n.somethingWentWrong,
  };
}
