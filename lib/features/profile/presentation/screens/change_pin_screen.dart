import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/application/pin_gate.dart';
import '../../../auth/application/pin_service.dart';
import '../../../auth/presentation/widgets/pin_pad.dart';
import '../../../../core/theme/app_typography.dart';

/// Stage of the change-PIN flow.
enum _Stage { verify, create, confirm }

/// Change (or set up) the on-device quick-unlock PIN.
///
/// When a PIN already exists the user must first re-enter it, then choose and
/// confirm a new one. With no PIN yet (rare), the verify step is skipped. The
/// PIN never leaves the device — it's stored via [PinService].
class ChangePinScreen extends ConsumerStatefulWidget {
  const ChangePinScreen({super.key});

  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen> {
  static const _length = 4;

  /// Null while we resolve whether a PIN already exists.
  _Stage? _stage;
  String _entry = '';
  String _newPin = '';
  String? _errorMsg;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _resolveStart();
  }

  Future<void> _resolveStart() async {
    final hasPin = await ref.read(pinServiceProvider).hasPin();
    if (!mounted) return;
    setState(() => _stage = hasPin ? _Stage.verify : _Stage.create);
  }

  Future<void> _onKey(String key) async {
    if (_busy || _stage == null) return;
    setState(() {
      if (_errorMsg != null) _errorMsg = null;
      if (key == kPinDelete) {
        if (_entry.isNotEmpty) _entry = _entry.substring(0, _entry.length - 1);
      } else if (_entry.length < _length) {
        _entry += key;
      }
    });
    if (_entry.length == _length) await _process();
  }

  Future<void> _process() async {
    final l10n = context.l10n;
    switch (_stage!) {
      case _Stage.verify:
        setState(() => _busy = true);
        final ok = await ref.read(pinServiceProvider).verify(_entry);
        if (!mounted) return;
        setState(() {
          _busy = false;
          if (ok) {
            _stage = _Stage.create;
            _entry = '';
          } else {
            _errorMsg = l10n.changePinWrong;
            _entry = '';
          }
        });
      case _Stage.create:
        if (PinService.isWeak(_entry)) {
          setState(() {
            _errorMsg = l10n.pinTooWeak;
            _entry = '';
          });
          return;
        }
        setState(() {
          _newPin = _entry;
          _stage = _Stage.confirm;
          _entry = '';
        });
      case _Stage.confirm:
        if (_entry == _newPin) {
          setState(() => _busy = true);
          await ref.read(pinServiceProvider).setPin(_newPin);
          // Keep the cold-start gate in sync (PIN now exists; session stays
          // unlocked since the user just set it).
          await ref.read(pinGateProvider).refresh();
          if (!mounted) return;
          showVentusSuccess(context, l10n.pinChanged);
          context.pop();
        } else {
          // Mismatch — restart from choosing a new PIN.
          setState(() {
            _errorMsg = l10n.changePinMismatch;
            _stage = _Stage.create;
            _newPin = '';
            _entry = '';
          });
        }
    }
  }

  ({String title, String body}) _copy(AppLocalizations l10n) {
    switch (_stage!) {
      case _Stage.verify:
        return (
          title: l10n.changePinVerifyTitle,
          body: l10n.changePinVerifyBody,
        );
      case _Stage.create:
        return (title: l10n.changePinNewTitle, body: l10n.changePinNewBody);
      case _Stage.confirm:
        return (
          title: l10n.changePinConfirmTitle,
          body: l10n.changePinConfirmBody,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;
    final l10n = context.l10n;

    return Scaffold(
      appBar: VentusAppBar(title: l10n.changePinTitle),
      body: SafeArea(
        top: false,
        child: _stage == null
            ? const Center(child: VentusSpinner())
            : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s6,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _copy(l10n).title,
                            style: type.h1.copyWith(fontSize: AppFontSize.h1),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.s2),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 260),
                            child: Text(
                              _copy(l10n).body,
                              style: type.sm.copyWith(color: colors.muted),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.s10),
                          PinDots(filled: _entry.length, total: _length),
                          const SizedBox(height: AppSpacing.s4),
                          SizedBox(
                            height: 20,
                            child: _errorMsg == null
                                ? null
                                : Text(
                                    _errorMsg!,
                                    style: type.sm.copyWith(
                                      color: colors.danger,
                                    ),
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
