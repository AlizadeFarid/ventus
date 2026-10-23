import '../../../../core/theme/app_colors.dart';
import 'dart:io' show Platform;
import '../../../../core/theme/app_overlay.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/feature_flags.dart';
import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../trips/application/trips_providers.dart';
import '../../../trips/domain/trip.dart';
import '../../application/profile_providers.dart';
import '../../../../core/theme/app_typography.dart';

/// Teal→amber avatar gradient — mirrors `AppColors.gradientHero` (prototype
/// `Profile.jsx` → AVA_GRAD). Kept const here as it feeds const collab lists.
const _avatarGradient = AppColors.heroGradient;

/// Profile hub (prototype `Profile.jsx` → Profile). Reached from the Profile
/// bottom-nav tab. The gear opens [SettingsScreen]; sub-screens (Collaborators,
/// Notifications, …) are stubbed until their features exist.
const _supportEmail = 'support@ventus.app';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profile = ref.watch(profileProvider);

    // Scaffold + SafeArea + bottom nav all come from [VentusShell] now.
    return ColoredBox(
      color: context.colors.bg,
      child: Column(
        children: [
          // header
          VentusTabTitle(l10n.navProfile),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Identity(profile: profile),
                  const SizedBox(height: 24),
                  if (AppFeatures.proPlan) ...[
                    _ProBanner(onTap: () => context.push(AppRoutes.pro)),
                    const SizedBox(height: 24),
                  ],
                  // Saved places are content the user built, not a preference,
                  // so they sit apart from the settings below.
                  _MenuCard(
                    items: [
                      _MenuItemData(
                        icon: VentusIcons.heart,
                        label: l10n.navSaved,
                        onTap: () => context.push(AppRoutes.saved),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  VentusSectionLabel(l10n.profileSectionPreferences),
                  _MenuCard(
                    items: [
                      _MenuItemData(
                        icon: VentusIcons.settings,
                        label: l10n.menuSettings,
                        onTap: () => context.push(AppRoutes.settings),
                      ),
                      _MenuItemData(
                        icon: VentusIcons.wallet,
                        label: l10n.menuCurrencyUnits,
                        onTap: () => context.push(AppRoutes.currencyUnits),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  VentusSectionLabel(l10n.profileSectionAccount),
                  _MenuCard(
                    items: [
                      if (AppFeatures.collaborators)
                        _MenuItemData(
                          icon: VentusIcons.user,
                          label: l10n.menuCollaborators,
                          onTap: () => _pickTripForCollaborators(context, ref),
                        ),
                      _MenuItemData(
                        icon: VentusIcons.shield,
                        label: l10n.menuPrivacySecurity,
                        onTap: () => context.push(AppRoutes.privacySecurity),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  VentusSectionLabel(l10n.profileSectionSupport),
                  _MenuCard(
                    items: [
                      _MenuItemData(
                        icon: VentusIcons.note,
                        label: l10n.menuHelp,
                        onTap: () => context.push(AppRoutes.help),
                      ),
                      _MenuItemData(
                        icon: VentusIcons.mail,
                        label: l10n.menuContact,
                        onTap: () => _contactSupport(context),
                      ),
                      _MenuItemData(
                        icon: VentusIcons.star,
                        label: l10n.menuAbout,
                        onTap: () => context.push(AppRoutes.about),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MenuCard(
                    items: [
                      _MenuItemData(
                        icon: VentusIcons.logout,
                        label: l10n.logOut,
                        danger: true,
                        onTap: () => _confirmSignOut(context, ref),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const _VersionLabel(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Opens the mail app with a prefilled message carrying the app version and
  /// device, so a bug report arrives with the context it needs.
  Future<void> _contactSupport(BuildContext context) async {
    final l10n = context.l10n;
    final failed = l10n.contactMailFailed;
    final subject = l10n.contactMailSubject;
    String version = '';
    try {
      final info = await PackageInfo.fromPlatform();
      version = 'Ventus ${info.version} (${info.buildNumber})';
    } catch (_) {}
    final device =
        '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
    if (!context.mounted) return;
    final body = l10n.contactMailBody(version, device);
    final uri = Uri.parse(
      'mailto:$_supportEmail'
      '?subject=${Uri.encodeComponent(subject)}'
      '&body=${Uri.encodeComponent(body)}',
    );
    var opened = false;
    try {
      opened = await launchUrl(uri);
    } catch (_) {}
    if (!opened && context.mounted) showVentusError(context, failed);
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await confirmVentusAction(
      context,
      title: l10n.signOutTitle,
      body: l10n.signOutBody,
      confirmLabel: l10n.signOut,
    );
    if (!ok) return;
    ref.read(authControllerProvider.notifier).signOut();
  }
}

/// Collaborators belong to a trip, so from Profile we first pick which trip to
/// manage, then open its Collaborators screen.
Future<void> _pickTripForCollaborators(
  BuildContext context,
  WidgetRef ref,
) async {
  final l10n = context.l10n;
  final trips = ref.read(tripsProvider).asData?.value ?? const <Trip>[];
  if (trips.isEmpty) {
    showVentusSnack(context, l10n.collabNoTrips);
    return;
  }
  final picked = await showVentusSheet<Trip>(
    context,
    isScrollControlled: false,
    builder: (_) => _TripPickerSheet(trips: trips),
  );
  if (picked == null || !context.mounted) return;
  context.push(AppRoutes.collaborators(picked.id));
}

class _TripPickerSheet extends StatelessWidget {
  const _TripPickerSheet({required this.trips});

  final List<Trip> trips;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VentusSheetHandle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
              child: Text(
                l10n.collabPickTrip,
                style: TextStyle(
                  fontSize: AppFontSize.body,
                  fontWeight: FontWeight.w700,
                  color: colors.ink,
                ),
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 8),
                itemCount: trips.length,
                separatorBuilder: (_, _) => const SizedBox.shrink(),
                itemBuilder: (_, i) {
                  final trip = trips[i];
                  return VentusTap(
                    onTap: () => Navigator.of(context).pop(trip),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trip.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: AppFontSize.body,
                                    fontWeight: FontWeight.w600,
                                    color: colors.ink,
                                  ),
                                ),
                                if (trip.country.isNotEmpty)
                                  Text(
                                    trip.country,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: AppFontSize.caption,
                                      color: colors.muted,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          VentusIcon(
                            VentusIcons.chevronRight,
                            size: 18,
                            color: colors.muted,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Identity extends StatelessWidget {
  const _Identity({required this.profile});

  final ProfileInfo profile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: () => context.push(AppRoutes.editProfile),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brLg,
          boxShadow: context.shadows.card,
        ),
        child: Row(
          children: [
            _GradientAvatar(
              initials: profile.initials,
              imageUrl: profile.avatarUrl,
              size: 48,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.body,
                      fontWeight: FontWeight.w600,
                      color: colors.ink,
                    ),
                  ),
                  if (profile.email.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      profile.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppFontSize.caption,
                        color: colors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            VentusIcon(VentusIcons.chevronRight, size: 18, color: colors.muted),
          ],
        ),
      ),
    );
  }
}

class _ProBanner extends StatelessWidget {
  const _ProBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          gradient: _avatarGradient,
          borderRadius: AppRadius.brLg,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF5502F).withValues(alpha: 0.32),
              offset: const Offset(0, 8),
              blurRadius: 22,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppOverlay.glassFill,
                borderRadius: AppRadius.brSm,
              ),
              child: const VentusIcon(
                VentusIcons.crown,
                size: 22,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.goVentusPro,
                    style: const TextStyle(
                      fontSize: AppFontSize.body,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.goVentusProSub,
                    style: const TextStyle(
                      fontSize: AppFontSize.caption,
                      color: AppOverlay.onPhotoStrong,
                    ),
                  ),
                ],
              ),
            ),
            const VentusIcon(
              VentusIcons.chevronRight,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItemData {
  const _MenuItemData({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.items});

  final List<_MenuItemData> items;

  @override
  Widget build(BuildContext context) {
    return VentusCard(
      children: [
        for (var i = 0; i < items.length; i++)
          _MenuRow(data: items[i], last: i == items.length - 1),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.data, required this.last});

  final _MenuItemData data;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = data.danger ? colors.danger : colors.ink;
    final iconFg = data.danger ? colors.danger : colors.ink2;

    return VentusTap(
      onTap: data.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            VentusLeadIcon(data.icon, color: iconFg),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                data.label,
                style: TextStyle(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ),
            if (!data.danger)
              VentusIcon(
                VentusIcons.chevronRight,
                size: 18,
                color: colors.muted,
              ),
          ],
        ),
      ),
    );
  }
}

class _GradientAvatar extends StatelessWidget {
  const _GradientAvatar({
    required this.initials,
    this.imageUrl,
    this.size = 44,
  });

  final String initials;
  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: hasImage ? null : _avatarGradient,
        shape: BoxShape.circle,
        image: hasImage
            ? DecorationImage(
                image: CachedNetworkImageProvider(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: hasImage
          ? null
          : Text(
              initials,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: size * 0.38,
              ),
            ),
    );
  }
}

/// App version under the menu — quiet, but it tells a TestFlight tester (and
/// you) exactly which build a bug report came from.
class _VersionLabel extends StatelessWidget {
  const _VersionLabel();

  static final Future<PackageInfo> _info = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<PackageInfo>(
        future: _info,
        builder: (context, snapshot) {
          final info = snapshot.data;
          final text = info == null
              ? ''
              : 'Ventus ${info.version} (${info.buildNumber})';
          return Text(
            text,
            style: context.typography.caption.copyWith(
              color: context.colors.muted,
            ),
          );
        },
      ),
    );
  }
}
