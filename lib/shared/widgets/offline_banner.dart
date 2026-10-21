import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/connectivity/connectivity_provider.dart';
import '../../core/extensions/theme_context_extension.dart';
import '../../core/l10n/l10n_extension.dart';
import 'ventus_icon.dart';

/// A slim strip that appears while the device has no network.
///
/// Deliberately quiet: the app keeps working offline (Drift is the source of
/// truth), so this explains rather than alarms — it is not an error state and
/// it blocks nothing. It animates its own height so appearing and disappearing
/// doesn't jolt the layout underneath.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    // While the first reachability check is still resolving, assume online —
    // flashing "you're offline" on every cold start would be worse than being
    // a beat late with it.
    final online = ref.watch(isOnlineProvider).asData?.value ?? true;

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: online
          ? const SizedBox(width: double.infinity)
          : Container(
              width: double.infinity,
              color: colors.amberSoft,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Row(
                children: [
                  VentusIcon(VentusIcons.cloud, size: 15, color: colors.amber),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      context.l10n.offlineBanner,
                      style: context.typography.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.ink2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
