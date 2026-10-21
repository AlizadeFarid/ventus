import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/notifications_controller.dart';
import '../../application/notifications_providers.dart';
import '../../domain/app_notification.dart';
import '../../domain/notification_type.dart';
import '../../../trips/application/collaborators_controller.dart';
import '../../../trips/application/trips_providers.dart';
import '../../../../core/utils/refresh.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Activity feed (prototype `Profile.jsx` → NotificationsFeed). Reached from the
/// Home bell. Notification settings (toggles) live in the Profile menu, not
/// here. Entries are produced by real events — a collaborator invite, an AI plan
/// finishing — and stored local-first.
class NotificationsFeedScreen extends ConsumerWidget {
  const NotificationsFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    // Pull remote notifications into Drift once when the feed opens.
    ref.watch(notificationsSyncProvider);
    final async = ref.watch(notificationsProvider);
    final items = async.asData?.value ?? const <AppNotification>[];
    final hasUnread = items.any((n) => !n.read);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: VentusAppBar(
        title: l10n.notificationsTitle,
        action: items.isNotEmpty ? _FeedMenu(hasUnread: hasUnread) : null,
      ),
      body: SafeArea(
        top: false,
        child: async.when(
          loading: () => const VentusListSkeleton(itemHeight: 72),
          error: (_, _) => Center(
            child: Text(
              l10n.somethingWentWrong,
              style: TextStyle(color: colors.muted),
            ),
          ),
          data: (list) => RefreshIndicator(
            onRefresh: () => refreshQuietly(
              () => ref.refresh(notificationsSyncProvider.future),
            ),
            child: list.isEmpty ? const _Empty() : _Feed(items: list),
          ),
        ),
      ),
    );
  }
}

class _Feed extends ConsumerWidget {
  const _Feed({required this.items});

  final List<AppNotification> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final now = DateTime.now();
    bool isToday(DateTime d) {
      final local = d.toLocal();
      return local.year == now.year &&
          local.month == now.month &&
          local.day == now.day;
    }

    final today = items.where((n) => isToday(n.createdAt)).toList();
    final earlier = items.where((n) => !isToday(n.createdAt)).toList();

    void markRead(AppNotification n) {
      if (!n.read) {
        ref.read(notificationsControllerProvider.notifier).markRead(n.id);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        6,
        AppSpacing.screen,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (today.isNotEmpty) ...[
            VentusSectionLabel(l10n.notifToday),
            for (var i = 0; i < today.length; i++)
              _NotifRow(
                item: today[i],
                last: i == today.length - 1,
                onTap: () => markRead(today[i]),
              ),
          ],
          if (earlier.isNotEmpty) ...[
            if (today.isNotEmpty) const SizedBox(height: 16),
            VentusSectionLabel(l10n.notifEarlier),
            for (var i = 0; i < earlier.length; i++)
              _NotifRow(
                item: earlier[i],
                last: i == earlier.length - 1,
                onTap: () => markRead(earlier[i]),
              ),
          ],
        ],
      ),
    );
  }
}

class _NotifRow extends ConsumerWidget {
  const _NotifRow({required this.item, required this.onTap, this.last = false});

  final AppNotification item;
  final VoidCallback onTap;
  final bool last;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final visual = _visualFor(item.kind, colors);
    final (title, body) = _textFor(item, l10n);

    // If the user already has this trip in their local database, they have
    // already accepted the invite (or they are the owner).
    final trips = ref.watch(tripsProvider).asData?.value ?? [];
    final isAccepted = trips.any((t) => t.id == item.tripId);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        ref.read(notificationsControllerProvider.notifier).delete(item.id);
      },
      background: const VentusSwipeDeleteBackground(),
      child: VentusTap(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: visual.bg,
                  borderRadius: AppRadius.brSm,
                ),
                child: VentusIcon(visual.icon, size: 19, color: visual.fg),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                        color: colors.ink,
                      ),
                    ),
                    if (body != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        body,
                        style: TextStyle(
                          fontSize: AppFontSize.sm,
                          height: 1.4,
                          color: colors.muted,
                        ),
                      ),
                    ],
                    const SizedBox(height: 5),
                    Text(
                      _relativeTime(item.createdAt, l10n),
                      style: TextStyle(
                        fontSize: AppFontSize.eyebrow,
                        fontWeight: FontWeight.w600,
                        color: colors.muted,
                      ),
                    ),
                    if (item.kind == NotificationType.collaboratorInvited &&
                        item.tripId != null &&
                        !isAccepted) ...[
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final success = await ref
                              .read(collaboratorsControllerProvider.notifier)
                              .acceptInvite(item.tripId!);
                          if (success && context.mounted) {
                            ref
                                .read(notificationsControllerProvider.notifier)
                                .markRead(item.id);
                            showVentusSuccess(context, l10n.notifAccepted);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.bg,
                          minimumSize: const Size(80, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          textStyle: const TextStyle(
                            fontSize: AppFontSize.sm,
                            fontWeight: FontWeight.w700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(l10n.notifAcceptInvite),
                      ),
                    ] else if (item.kind ==
                            NotificationType.collaboratorInvited &&
                        item.tripId != null &&
                        isAccepted) ...[
                      const SizedBox(height: 10),
                      Text(
                        l10n.notifAccepted,
                        style: TextStyle(
                          fontSize: AppFontSize.sm,
                          fontWeight: FontWeight.w700,
                          color: context.primaryFill,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!item.read) ...[
                const SizedBox(width: 10),
                Container(
                  width: 9,
                  height: 9,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return VentusEmptyState(
      icon: VentusIcons.bell,
      title: l10n.notifEmptyTitle,
      body: l10n.notifEmptyBody,
    );
  }
}

class _FeedMenu extends ConsumerWidget {
  const _FeedMenu({required this.hasUnread});

  final bool hasUnread;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;

    return PopupMenuButton<int>(
      icon: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surface,
          shape: BoxShape.circle,
          boxShadow: context.shadows.card,
        ),
        child: VentusIcon(VentusIcons.more, size: 20, color: colors.ink),
      ),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.brMd),
      color: colors.surface,
      position: PopupMenuPosition.under,
      onSelected: (val) {
        if (val == 0) {
          confirmVentusAction(
            context,
            title: l10n.notifConfirmMarkAllReadTitle,
            body: l10n.notifConfirmMarkAllReadBody,
            confirmLabel: l10n.notifMarkReadConfirm,
          ).then((ok) {
            if (!ok) return;
            ref.read(notificationsControllerProvider.notifier).markAllRead();
          });
        } else if (val == 1) {
          confirmVentusAction(
            context,
            title: l10n.notifConfirmDeleteAllTitle,
            body: l10n.notifConfirmDeleteAllBody,
            confirmLabel: l10n.notifDeleteAllConfirm,
            destructive: true,
          ).then((ok) {
            if (!ok) return;
            ref.read(notificationsControllerProvider.notifier).deleteAll();
          });
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          enabled: hasUnread,
          child: Row(
            children: [
              VentusIcon(
                VentusIcons.listCheck,
                size: 18,
                color: hasUnread ? colors.ink : colors.muted,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.notifMarkRead,
                style: TextStyle(color: hasUnread ? colors.ink : colors.muted),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              VentusIcon(VentusIcons.trash, size: 18, color: colors.danger),
              const SizedBox(width: 12),
              Text(l10n.notifDeleteAll, style: TextStyle(color: colors.danger)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Icon + soft background + foreground colour for a notification kind.
typedef _Visual = ({String icon, Color bg, Color fg});

_Visual _visualFor(NotificationType kind, AppColors c) {
  switch (kind) {
    case NotificationType.welcome:
      return (icon: VentusIcons.compass, bg: c.primarySoft, fg: c.primary);
    case NotificationType.collaboratorInvited:
      return (icon: VentusIcons.user, bg: c.primarySoft, fg: c.primary);
    case NotificationType.aiPlanReady:
      return (icon: VentusIcons.sparkle, bg: c.primarySoft, fg: c.primary);
    case NotificationType.generic:
      return (icon: VentusIcons.bell, bg: c.primarySoft, fg: c.primary);
  }
}

/// Localized (title, body?) for a notification, derived from its kind + fields
/// so it follows the active language rather than a creation-time snapshot.
(String, String?) _textFor(AppNotification n, AppLocalizations l10n) {
  switch (n.kind) {
    case NotificationType.welcome:
      return (l10n.notifWelcomeTitle, l10n.notifWelcomeBody);
    case NotificationType.collaboratorInvited:
      final title = l10n.notifCollabInvitedTitle(n.subject ?? '');
      final body = n.tripTitle != null
          ? l10n.notifCollabInvitedBody(n.tripTitle!)
          : l10n.notifCollabInvitedBodyShort;
      return (title, body);
    case NotificationType.aiPlanReady:
      final body = n.tripTitle != null
          ? l10n.notifAiReadyBody(n.tripTitle!)
          : null;
      return (l10n.notifAiReadyTitle, body);
    case NotificationType.generic:
      return (l10n.notifGenericTitle, null);
  }
}

/// "5 dəq əvvəl" / "3 saat əvvəl" style relative label. Deliberately a
/// duration rather than a formatted clock reading, so it reads correctly
/// regardless of whether the device's timezone/region is set up right — a
/// wall-clock time (e.g. "14:32") would otherwise visibly disagree with the
/// reader's own watch whenever that's off.
String _relativeTime(DateTime when, AppLocalizations l10n) {
  final diff = DateTime.now().difference(when.toLocal());
  if (diff.inMinutes < 1) return l10n.timeJustNow;
  if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
  if (diff.inDays < 2) return l10n.timeYesterday;
  if (diff.inDays < 7) return l10n.timeDaysAgo(diff.inDays);
  return DateFormat.yMMMd().format(when.toLocal());
}
