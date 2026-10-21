import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../profile/application/profile_providers.dart';
import '../../application/auth_controller.dart';
import '../../application/pin_gate.dart';
import '../../application/pin_service.dart';
import '../widgets/pin_pad.dart';
import '../../../../core/theme/app_typography.dart';

/// Quick-unlock with the stored PIN, from the prototype `Auth.jsx` (PinUnlock).
class PinUnlockScreen extends ConsumerStatefulWidget {
  const PinUnlockScreen({super.key});

  @override
  ConsumerState<PinUnlockScreen> createState() => _PinUnlockScreenState();
}

class _PinUnlockScreenState extends ConsumerState<PinUnlockScreen> {
  static const _length = 4;
  String _pin = '';
  bool _checking = false;

  Future<void> _onKey(String key) async {
    if (_checking) return;
    setState(() {
      if (key == kPinDelete) {
        if (_pin.isNotEmpty) _pin = _pin.substring(0, _pin.length - 1);
      } else if (_pin.length < _length) {
        _pin += key;
      }
    });

    if (_pin.length == _length) {
      setState(() => _checking = true);
      final ok = await ref.read(pinServiceProvider).verify(_pin);
      if (!mounted) return;
      if (ok) {
        ref.read(pinGateProvider).unlock();
        context.go(AppRoutes.home);
      } else {
        final lockedFor = await ref
            .read(pinServiceProvider)
            .lockoutSecondsRemaining();
        if (!mounted) return;
        final message = lockedFor > 0
            ? '${context.l10n.pinLockedOut} ${lockedFor}s'
            : context.l10n.incorrectPin;
        showVentusError(context, message);
        setState(() {
          _pin = '';
          _checking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;
    final l10n = context.l10n;
    final name = ref.watch(profileProvider).name;
    final initial = name.trim().isEmpty
        ? 'V'
        : name.trim().characters.first.toUpperCase();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      initial,
                      style: type.h1.copyWith(
                        fontSize: AppFontSize.h1,
                        fontWeight: FontWeight.w800,
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  Text(
                    l10n.greeting(name),
                    style: type.h1.copyWith(fontSize: AppFontSize.h1),
                  ),
                  const SizedBox(height: AppSpacing.s1),
                  Text(
                    l10n.enterPinToUnlock,
                    style: type.sm.copyWith(color: colors.muted),
                  ),
                  const SizedBox(height: AppSpacing.s10),
                  PinDots(filled: _pin.length, total: _length),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
              child: PinKeypad(onKey: _onKey),
            ),
            const SizedBox(height: AppSpacing.s4),
            VentusTap(
              onTap: () => ref.read(authControllerProvider.notifier).signOut(),
              child: Text(
                l10n.usePasswordInstead,
                style: type.sm.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryFill,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s4),
          ],
        ),
      ),
    );
  }
}
