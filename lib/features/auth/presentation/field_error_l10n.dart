import '../../../core/utils/validators.dart';
import '../../../l10n/app_localizations.dart';

/// Maps a [FieldError] to a localized, user-facing message.
extension FieldErrorL10n on FieldError {
  String message(AppLocalizations l10n) => switch (this) {
    FieldError.emailRequired => l10n.errEmailRequired,
    FieldError.emailInvalid => l10n.errEmailInvalid,
    FieldError.passwordRequired => l10n.errPasswordRequired,
    FieldError.passwordTooShort => l10n.errPasswordTooShort,
    FieldError.nameRequired => l10n.errNameRequired,
  };
}
