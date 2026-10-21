import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../auth/domain/auth_exception.dart';
import '../../../auth/presentation/field_error_l10n.dart';

/// Change — or, for an OAuth-only account, *set* — the signed-in user's
/// password.
///
/// A Google/Apple account has no password on it, so asking for the "current
/// password" was unanswerable: whatever the user typed was rejected and there
/// was no way through. When [hasPasswordLoginProvider] reports no password
/// login, this drops the current-password field, explains why, and sets the
/// first password instead.
///
/// Otherwise the current password is re-verified server-side (so an unlocked
/// session can't silently change it) before the new one is applied.
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();

  String? _currentError;
  String? _newError;
  String? _confirmError;

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit({required bool hasPassword}) async {
    final l10n = context.l10n;
    final newError = Validators.password(_new.text);
    setState(() {
      _currentError = hasPassword && _current.text.isEmpty
          ? FieldError.passwordRequired.message(l10n)
          : null;
      _newError = newError?.message(l10n);
      _confirmError = _confirm.text != _new.text
          ? l10n.passwordsDontMatch
          : null;
    });
    if (_currentError != null || _newError != null || _confirmError != null) {
      return;
    }

    final ok = await ref
        .read(authControllerProvider.notifier)
        .changePassword(
          currentPassword: hasPassword ? _current.text : null,
          newPassword: _new.text,
        );
    if (!mounted) return;
    if (ok) {
      ref.invalidate(hasPasswordLoginProvider);
      showVentusSuccess(
        context,
        hasPassword ? l10n.passwordChanged : l10n.passwordSet,
      );
      context.pop();
    } else {
      _showError();
    }
  }

  /// Maps the controller's error onto the most relevant field (or a snackbar).
  void _showError() {
    final l10n = context.l10n;
    final error = ref.read(authControllerProvider).error;
    final code = error is AuthException ? error.code : AuthErrorCode.unknown;
    switch (code) {
      case AuthErrorCode.invalidCredentials:
        setState(() => _currentError = l10n.currentPasswordIncorrect);
      case AuthErrorCode.weakPassword:
        setState(() => _newError = l10n.authWeakPassword);
      case AuthErrorCode.samePassword:
        setState(() => _newError = l10n.authSamePassword);
      default:
        showVentusError(context, l10n.somethingWentWrong);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final loading = ref.watch(authControllerProvider).isLoading;
    // Assume the classic email+password account until proven otherwise, so the
    // familiar form never flickers into view for the majority of users.
    final hasPassword =
        ref.watch(hasPasswordLoginProvider).asData?.value ?? true;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: VentusAppBar(
        title: hasPassword ? l10n.changePasswordTitle : l10n.setPasswordTitle,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  12,
                  AppSpacing.screen,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasPassword) ...[
                      VentusTextField(
                        label: l10n.currentPasswordLabel,
                        icon: VentusIcons.lock,
                        hintText: '••••••••',
                        controller: _current,
                        obscure: true,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.password],
                        errorText: _currentError,
                        onChanged: (_) {
                          if (_currentError != null) {
                            setState(() => _currentError = null);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                    ] else ...[
                      _OAuthNote(text: l10n.setPasswordNote),
                      const SizedBox(height: 18),
                    ],
                    VentusTextField(
                      label: l10n.newPasswordLabel,
                      icon: VentusIcons.lock,
                      hintText: '••••••••',
                      controller: _new,
                      obscure: true,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      errorText: _newError,
                      onChanged: (_) {
                        if (_newError != null) setState(() => _newError = null);
                      },
                    ),
                    const SizedBox(height: 16),
                    VentusTextField(
                      label: l10n.confirmPasswordLabel,
                      icon: VentusIcons.lock,
                      hintText: '••••••••',
                      controller: _confirm,
                      obscure: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      errorText: _confirmError,
                      onChanged: (_) {
                        if (_confirmError != null) {
                          setState(() => _confirmError = null);
                        }
                      },
                      onSubmitted: (_) => _submit(hasPassword: hasPassword),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                8,
                AppSpacing.screen,
                24,
              ),
              child: VentusButton(
                label: hasPassword
                    ? l10n.changePasswordAction
                    : l10n.setPasswordAction,
                full: true,
                loading: loading,
                onPressed: loading
                    ? null
                    : () => _submit(hasPassword: hasPassword),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Explains why an OAuth-only account is being asked to *set* a password
/// rather than change one.
class _OAuthNote extends StatelessWidget {
  const _OAuthNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.primarySoft,
        borderRadius: AppRadius.brMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VentusIcon(VentusIcons.shield, size: 17, color: colors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: context.typography.sm.copyWith(color: colors.ink2),
            ),
          ),
        ],
      ),
    );
  }
}
