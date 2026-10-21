/// A localizable form-validation outcome. Validators return one of these (or
/// `null` when valid) instead of a hard-coded string, so the presentation layer
/// can map it to the active language. See `FieldErrorL10n` for the messages.
enum FieldError {
  emailRequired,
  emailInvalid,
  passwordRequired,
  passwordTooShort,
  nameRequired,
}

/// Reusable form-field validators. Each returns a [FieldError], or `null` when
/// the value is valid.
abstract final class Validators {
  static final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  static FieldError? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return FieldError.emailRequired;
    if (!_emailRegex.hasMatch(v)) return FieldError.emailInvalid;
    return null;
  }

  static FieldError? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return FieldError.passwordRequired;
    if (v.length < 8) return FieldError.passwordTooShort;
    return null;
  }

  static FieldError? name(String? value) {
    if ((value?.trim() ?? '').isEmpty) return FieldError.nameRequired;
    return null;
  }
}
