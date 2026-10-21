import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/auth_controller.dart';
import '../../domain/auth_exception.dart';
import '../auth_error_l10n.dart';
import '../field_error_l10n.dart';
import '../../../../core/theme/app_typography.dart';

/// Completes a password reset with the 6-digit code emailed to the user, then
/// sets a new password. Fully in-app (no deep link). Reached from the forgot
/// screen after the reset email is sent.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _codeError;
  FieldError? _passwordError;
  String? _confirmError;

  @override
  void dispose() {
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _code.text.trim();
    final passwordError = Validators.password(_password.text);
    final confirmError = _confirm.text != _password.text
        ? context.l10n.passwordsDontMatch
        : null;
    setState(() {
      _codeError = code.length < 6 ? context.l10n.authInvalidOtp : null;
      _passwordError = passwordError;
      _confirmError = confirmError;
    });
    if (_codeError != null || passwordError != null || confirmError != null) {
      return;
    }

    final ok = await ref
        .read(authControllerProvider.notifier)
        .resetPasswordWithToken(
          email: widget.email,
          token: code,
          newPassword: _password.text,
        );
    if (!mounted) return;
    if (ok) {
      showVentusSuccess(context, context.l10n.resetSuccess);
      // Recovery created a valid session → continue like a normal sign-in.
      context.go(AppRoutes.home);
      return;
    }
    final error = ref.read(authControllerProvider).error;
    final code2 = error is AuthException ? error.code : AuthErrorCode.unknown;
    if (code2 == AuthErrorCode.invalidOtp) {
      setState(() => _codeError = context.l10n.authInvalidOtp);
    } else if (code2 == AuthErrorCode.weakPassword) {
      setState(() => _passwordError = FieldError.passwordTooShort);
    } else {
      showVentusError(context, code2.message(context.l10n));
    }
  }

  Future<void> _resend() async {
    final l10n = context.l10n;
    final ok = await ref
        .read(authControllerProvider.notifier)
        .sendReset(widget.email);
    if (!mounted) return;
    if (ok) {
      showVentusSuccess(context, l10n.resetResent);
    } else {
      showVentusError(context, l10n.somethingWentWrong, onRetry: _resend);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;
    final l10n = context.l10n;
    final loading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: VentusAppBar(title: l10n.resetPasswordTitle),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s6,
            AppSpacing.s6,
            AppSpacing.s6,
            AppSpacing.s8,
          ),
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.primarySoft,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: VentusIcon(
                VentusIcons.lock,
                size: 30,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.s5),
            Text(
              l10n.resetCodeTitle,
              style: type.h1.copyWith(
                fontSize: AppFontSize.h1,
                height: 31 / 27,
              ),
            ),
            const SizedBox(height: AppSpacing.s3),
            Text(
              l10n.resetCodeBody(widget.email),
              style: type.body.copyWith(height: 23 / 16, color: colors.muted),
            ),
            const SizedBox(height: AppSpacing.s6),
            VentusTextField(
              label: l10n.resetCodeLabel,
              icon: VentusIcons.mail,
              hintText: l10n.resetCodeHint,
              controller: _code,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              errorText: _codeError,
              onChanged: (_) {
                if (_codeError != null) setState(() => _codeError = null);
              },
            ),
            const SizedBox(height: AppSpacing.s4),
            VentusTextField(
              label: l10n.newPasswordLabel,
              icon: VentusIcons.lock,
              hintText: l10n.passwordHintMin,
              controller: _password,
              obscure: true,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              errorText: _passwordError?.message(l10n),
              onChanged: (_) {
                if (_passwordError != null) {
                  setState(() => _passwordError = null);
                }
              },
            ),
            const SizedBox(height: AppSpacing.s4),
            VentusTextField(
              label: l10n.confirmPasswordLabel,
              icon: VentusIcons.lock,
              hintText: l10n.passwordHintMin,
              controller: _confirm,
              obscure: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              errorText: _confirmError,
              onChanged: (_) {
                if (_confirmError != null) setState(() => _confirmError = null);
              },
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.s6),
            VentusButton(
              label: l10n.resetSubmit,
              full: true,
              loading: loading,
              onPressed: _submit,
            ),
            const SizedBox(height: AppSpacing.s4),
            Center(
              child: VentusTap(
                onTap: loading ? null : _resend,
                child: Text(
                  l10n.resetResend,
                  style: type.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.primaryFill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
