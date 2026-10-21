import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/feature_flags.dart';
import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/preferences/notification_prefs_provider.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Notification settings (prototype `NotifSettings`): grouped on/off switches,
/// persisted via [notificationPrefsProvider]. Reached from the Profile menu's
/// "Notifications" row. The activity feed (prototype `NotificationsFeed`) is
/// deferred until there's a backend that produces notifications.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final prefs = ref.watch(notificationPrefsProvider);

    void toggle(NotificationKind k) =>
        ref.read(notificationPrefsProvider.notifier).toggle(k);

    final sections = <(String, List<_RowData>)>[
      (
        l10n.notifSectionTripActivity,
        [
          if (AppFeatures.collaborators)
            _RowData(
              NotificationKind.collaboratorChanges,
              l10n.notifCollaboratorChanges,
              l10n.notifCollaboratorChangesSub,
            ),
          _RowData(
            NotificationKind.itineraryUpdates,
            l10n.notifItineraryUpdates,
            null,
          ),
          _RowData(
            NotificationKind.checklistReminders,
            l10n.notifChecklistReminders,
            l10n.notifChecklistRemindersSub,
          ),
        ],
      ),
      (
        l10n.notifSectionTravelAlerts,
        [
          _RowData(
            NotificationKind.weatherChanges,
            l10n.notifWeatherChanges,
            null,
          ),
          _RowData(
            NotificationKind.documentExpiry,
            l10n.notifDocumentExpiry,
            l10n.notifDocumentExpirySub,
          ),
          _RowData(
            NotificationKind.checkInDeparture,
            l10n.notifCheckInDeparture,
            null,
          ),
        ],
      ),
      (
        l10n.notifSectionVentus,
        [
          _RowData(NotificationKind.travelTips, l10n.notifTravelTips, null),
          _RowData(NotificationKind.productNews, l10n.notifProductNews, null),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: VentusAppBar(title: l10n.notificationSettingsTitle),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            8,
            AppSpacing.screen,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (label, rows) in sections) ...[
                VentusSectionLabel(label),
                VentusCard(
                  children: [
                    for (var i = 0; i < rows.length; i++)
                      _ToggleRow(
                        label: rows[i].label,
                        sub: rows[i].sub,
                        value: prefs[rows[i].kind] ?? true,
                        onChanged: (_) => toggle(rows[i].kind),
                        last: i == rows.length - 1,
                      ),
                  ],
                ),
                const SizedBox(height: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RowData {
  const _RowData(this.kind, this.label, this.sub);

  final NotificationKind kind;
  final String label;
  final String? sub;
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.sub,
    this.last = false,
  });

  final String label;
  final String? sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
                if (sub != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    sub!,
                    style: TextStyle(
                      fontSize: AppFontSize.caption,
                      color: colors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          VentusToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
