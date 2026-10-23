import 'package:flutter/gestures.dart';
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

/// Create account · variant B (minimal), from the prototype `Auth.jsx`.
class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  // Consent is never pre-ticked: the user has to opt in themselves.
  bool _agreed = false;
  FieldError? _nameError;
  FieldError? _emailError;
  FieldError? _passwordError;

  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()
      ..onTap = () => context.push(AppRoutes.terms);
    _privacyTap = TapGestureRecognizer()
      ..onTap = () => context.push(AppRoutes.privacy);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  /// Builds the consent label with tappable "Terms" / "Privacy" links from the
  /// localized `[terms]` / `[privacy]` template, so word order stays correct.
  Widget _agreeLabel(BuildContext context) {
    final type = context.typography;
    final colors = context.colors;
    final l10n = context.l10n;
    final base = type.sm.copyWith(color: colors.ink2);
    final link = base.copyWith(
      color: context.primaryFill,
      fontWeight: FontWeight.w600,
    );

    final template = l10n.agreeTermsRich;
    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final m in RegExp(r'\[terms\]|\[privacy\]').allMatches(template)) {
      if (m.start > cursor) {
        spans.add(
          TextSpan(text: template.substring(cursor, m.start), style: base),
        );
      }
      final isTerms = m.group(0) == '[terms]';
      spans.add(
        TextSpan(
          text: isTerms ? l10n.termsLinkLabel : l10n.privacyLinkLabel,
          style: link,
          recognizer: isTerms ? _termsTap : _privacyTap,
        ),
      );
      cursor = m.end;
    }
    if (cursor < template.length) {
      spans.add(TextSpan(text: template.substring(cursor), style: base));
    }
    return Text.rich(TextSpan(children: spans));
  }

  Future<void> _submit() async {
    final nameError = Validators.name(_name.text);
    final emailError = Validators.email(_email.text);
    final passwordError = Validators.password(_password.text);
    setState(() {
      _nameError = nameError;
      _emailError = emailError;
      _passwordError = passwordError;
    });
    if (nameError != null || emailError != null || passwordError != null) {
      return;
    }
    if (!_agreed) {
      _snack(context.l10n.acceptTermsError);
      return;
    }

    final result = await ref
        .read(authControllerProvider.notifier)
        .signUp(name: _name.text, email: _email.text, password: _password.text);
    if (!mounted) return;
    switch (result) {
      case SignUpResult.confirmed:
        // No email confirmation required → straight into the app. A PIN is
        // optional and can be set later from Profile → Privacy & security.
        context.go(AppRoutes.home);
      case SignUpResult.needsVerification:
        // Confirmation required → tell the user to check their inbox.
        context.go(AppRoutes.verifyEmail(_email.text.trim()));
      case SignUpResult.failed:
        final error = ref.read(authControllerProvider).error;
        final message = error is AuthException
            ? error.code.message(context.l10n)
            : context.l10n.somethingWentWrong;
        _snack(message);
    }
  }

  void _snack(String message) {
    showVentusError(context, message);
  }

  /// Runs a social sign-in, then routes into the app on success (or shows the
  /// error; cancellations are silent).
  Future<void> _oauth(Future<bool> Function() action) async {
    final ok = await action();
    if (!mounted) return;
    if (ok) {
      context.go(AppRoutes.home);
      return;
    }
    final error = ref.read(authControllerProvider).error;
    if (error is AuthException && error.code != AuthErrorCode.cancelled) {
      _snack(error.code.message(context.l10n));
    }
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
        // Scrolls when the keyboard (or a large text size) leaves less room than
        // the form needs; otherwise it fills the screen so the footer link stays
        // pinned to the bottom.
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.s2,
                  AppSpacing.screen,
                  AppSpacing.s5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.createAccountTitle, style: type.h1),
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      l10n.createAccountSubtitle,
                      style: type.body.copyWith(color: colors.muted),
                    ),
                    const SizedBox(height: AppSpacing.s6),
                    VentusTextField(
                      label: l10n.fullNameLabel,
                      icon: VentusIcons.user,
                      hintText: l10n.fullNameHint,
                      controller: _name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      errorText: _nameError?.message(l10n),
                      onChanged: (_) {
                        if (_nameError != null) {
                          setState(() => _nameError = null);
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.s4),
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
                        if (_emailError != null) {
                          setState(() => _emailError = null);
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    VentusTextField(
                      label: l10n.passwordLabel,
                      icon: VentusIcons.lock,
                      hintText: l10n.passwordHintMin,
                      controller: _password,
                      obscure: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      errorText: _passwordError?.message(l10n),
                      onChanged: (_) {
                        if (_passwordError != null) {
                          setState(() => _passwordError = null);
                        }
                      },
                      onSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: AppSpacing.s6),
                    VentusCheckbox(
                      value: _agreed,
                      labelWidget: _agreeLabel(context),
                      onChanged: (v) => setState(() => _agreed = v),
                    ),
                    const SizedBox(height: AppSpacing.s6),
                    VentusButton(
                      label: l10n.createAccountAction,
                      size: VentusButtonSize.lg,
                      full: true,
                      loading: loading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    VentusDivider(label: l10n.orDivider),
                    const SizedBox(height: AppSpacing.s4),
                    AuthSocialRow(
                      onGoogle: () => _oauth(
                        ref
                            .read(authControllerProvider.notifier)
                            .signInWithGoogle,
                      ),
                      onApple: () => _oauth(
                        ref
                            .read(authControllerProvider.notifier)
                            .signInWithApple,
                      ),
                    ),
                    const Spacer(),
                    // Minimum gap: when errors make the form fill the screen the Spacer
                    // collapses to zero and the footer would touch the buttons above.
                    const SizedBox(height: AppSpacing.s6),
                    Center(
                      child: AuthFooterLink(
                        question: l10n.alreadyHaveAccount,
                        action: l10n.signInAction,
                        // Swap to the sibling screen while keeping welcome underneath.
                        onTap: () => context.pushReplacement(AppRoutes.signIn),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
