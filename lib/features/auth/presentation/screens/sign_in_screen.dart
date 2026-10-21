import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/auth_controller.dart';
import '../../domain/auth_exception.dart';
import '../auth_error_l10n.dart';
import '../field_error_l10n.dart';
import '../widgets/auth_footer_link.dart';
import '../widgets/auth_social_row.dart';
import '../../../../core/theme/app_typography.dart';

/// Sign in · variant B (minimal), from the prototype `Auth.jsx`.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = true;
  FieldError? _emailError;
  FieldError? _passwordError;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final emailError = Validators.email(_email.text);
    final passwordError = Validators.password(_password.text);
    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });
    if (emailError != null || passwordError != null) return;

    final ok = await ref
        .read(authControllerProvider.notifier)
        .signIn(email: _email.text, password: _password.text);
    if (!mounted) return;
    if (ok) {
      context.go(AppRoutes.home);
      return;
    }
    // An unconfirmed account can't sign in yet → send them to the verify screen
    // (where they can resend the link) rather than just flashing an error.
    final error = ref.read(authControllerProvider).error;
    if (error is AuthException &&
        error.code == AuthErrorCode.emailNotConfirmed) {
      context.go(AppRoutes.verifyEmail(_email.text.trim()));
      return;
    }
    _showError();
  }

  void _showError() {
    final error = ref.read(authControllerProvider).error;
    final message = error is AuthException
        ? error.code.message(context.l10n)
        : context.l10n.somethingWentWrong;
    showVentusError(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;
    final l10n = context.l10n;
    final loading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: const VentusAppBar(),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s6,
            AppSpacing.s2,
            AppSpacing.s6,
            AppSpacing.s5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.welcomeBack,
                style: type.display.copyWith(
                  fontSize: AppFontSize.h1,
                  height: 34 / 30,
                  letterSpacing: 30 * -0.03,
                ),
              ),
              const SizedBox(height: AppSpacing.s2),
              Text(
                l10n.signInSubtitle,
                style: type.body.copyWith(color: colors.muted),
              ),
              const SizedBox(height: AppSpacing.s6),
              VentusTextField(
                label: l10n.emailLabel,
                icon: VentusIcons.mail,
                hintText: l10n.emailHint,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                errorText: _emailError?.message(l10n),
                onChanged: (_) {
                  if (_emailError != null) setState(() => _emailError = null);
                },
              ),
              const SizedBox(height: AppSpacing.s4),
              VentusTextField(
                label: l10n.passwordLabel,
                icon: VentusIcons.lock,
                hintText: '••••••••',
                controller: _password,
                obscure: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                errorText: _passwordError?.message(l10n),
                onChanged: (_) {
                  if (_passwordError != null) {
                    setState(() => _passwordError = null);
                  }
                },
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: AppSpacing.s3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  VentusCheckbox(
                    value: _remember,
                    label: l10n.rememberMe,
                    onChanged: (v) => setState(() => _remember = v),
                  ),
                  VentusTap(
                    onTap: () => context.push(AppRoutes.forgotPassword),
                    child: Text(
                      l10n.forgot,
                      style: type.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.primaryFill,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s4),
              VentusButton(
                label: l10n.signInAction,
                full: true,
                loading: loading,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.s4),
              VentusDivider(label: l10n.orDivider),
              const SizedBox(height: AppSpacing.s4),
              AuthSocialRow(
                onGoogle: () => _oauth(
                  ref.read(authControllerProvider.notifier).signInWithGoogle,
                ),
                onApple: () => _oauth(
                  ref.read(authControllerProvider.notifier).signInWithApple,
                ),
              ),
              const Spacer(),
              Center(
                child: AuthFooterLink(
                  question: l10n.newToVentus,
                  action: l10n.createAccountAction,
                  // Swap to the sibling screen while keeping welcome underneath.
                  onTap: () => context.pushReplacement(AppRoutes.createAccount),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Runs a social sign-in, then routes to PIN setup on success (or shows the
  /// error; cancellations are silent).
  Future<void> _oauth(Future<bool> Function() action) async {
    final ok = await action();
    if (!mounted) return;
    if (ok) {
      context.go(AppRoutes.home);
      return;
    }
    final error = ref.read(authControllerProvider).error;
    if (error != null) _showError();
  }
}
