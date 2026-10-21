import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/pin_gate.dart';
import '../../application/pin_service.dart';
import '../widgets/pin_pad.dart';
import '../../../../core/theme/app_typography.dart';

/// Create a 4-digit quick-unlock PIN, from the prototype `Auth.jsx` (PinSetup).
///
/// On completion the PIN is stored on-device via [PinService] and the user
/// continues into the app.
class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  static const _length = 4;
  String _pin = '';
  bool _saving = false;
  String? _errorMsg;

  Future<void> _onKey(String key) async {
    if (_saving) return;
    setState(() {
      if (_errorMsg != null) _errorMsg = null;
      if (key == kPinDelete) {
        if (_pin.isNotEmpty) _pin = _pin.substring(0, _pin.length - 1);
      } else if (_pin.length < _length) {
        _pin += key;
      }
    });

    if (_pin.length == _length) {
      if (PinService.isWeak(_pin)) {
        setState(() {
          _errorMsg = context.l10n.pinTooWeak;
          _pin = '';
        });
        return;
      }
      setState(() => _saving = true);
      await ref.read(pinServiceProvider).setPin(_pin);
      // Mark the gate as unlocked + PIN-enabled so it doesn't immediately lock.
      await ref.read(pinGateProvider).refresh();
      if (!mounted) return;
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;
    final l10n = context.l10n;

    return Scaffold(
      appBar: const VentusAppBar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.createPinTitle,
                      style: type.h1.copyWith(fontSize: AppFontSize.h1),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 260),
                      child: Text(
                        l10n.createPinBody,
                        style: type.sm.copyWith(color: colors.muted),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s10),
                    PinDots(filled: _pin.length, total: _length),
                    const SizedBox(height: AppSpacing.s4),
                    SizedBox(
                      height: 20,
                      child: _errorMsg == null
                          ? null
                          : Text(
                              _errorMsg!,
                              style: type.sm.copyWith(color: colors.danger),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s6,
                0,
                AppSpacing.s6,
                AppSpacing.s5,
              ),
              child: PinKeypad(onKey: _onKey),
            ),
          ],
        ),
      ),
    );
  }
}
