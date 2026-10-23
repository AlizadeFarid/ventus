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
import '../field_error_l10n.dart';
import '../widgets/auth_footer_link.dart';

/// Forgot password, from the prototype `Auth.jsx` (ForgotA).
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();
  FieldError? _emailError;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final emailError = Validators.email(_email.text);
    setState(() => _emailError = emailError);
    if (emailError != null) return;

    final ok = await ref
        .read(authControllerProvider.notifier)
        .sendReset(_email.text);
    if (!mounted) return;
    if (ok) {
      // Move on to enter the emailed code + choose a new password.
      context.push(AppRoutes.resetPassword(_email.text.trim()));
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
        // Scrolls when the keyboard leaves less room than the form needs;
        // otherwise it fills the screen so the footer link stays at the bottom.
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
                    Text(l10n.forgotTitle, style: type.h1),
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      l10n.forgotBody,
                      style: type.body.copyWith(color: colors.muted),
                    ),
                    const SizedBox(height: AppSpacing.s6),
                    VentusTextField(
                      label: l10n.emailLabel,
                      icon: VentusIcons.mail,
                      hintText: l10n.emailHint,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.email],
                      errorText: _emailError?.message(l10n),
                      onChanged: (_) {
                        if (_emailError != null) {
                          setState(() => _emailError = null);
                        }
                      },
                      onSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: AppSpacing.s6),
                    VentusButton(
                      label: l10n.sendResetLink,
                      size: VentusButtonSize.lg,
                      full: true,
                      loading: loading,
                      onPressed: _submit,
                    ),
                    const Spacer(),
                    // Minimum gap: when errors make the form fill the screen the Spacer
                    // collapses to zero and the footer would touch the buttons above.
                    const SizedBox(height: AppSpacing.s6),
                    Center(
                      child: AuthFooterLink(
                        question: l10n.rememberedIt,
                        action: l10n.backToSignIn,
                        onTap: () => context.pop(),
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
