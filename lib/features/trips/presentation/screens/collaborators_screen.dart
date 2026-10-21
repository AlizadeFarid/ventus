import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../profile/application/profile_providers.dart';
import '../../application/collaborators_controller.dart';
import '../../application/collaborators_providers.dart';
import '../../application/trip_detail_providers.dart';
import '../../domain/collaborator.dart';
import '../../domain/collaborator_role.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Avatar gradients (prototype `Profile.jsx`): owner teal→amber, collaborators
/// cycle through sea / green / owner.
const _ownerGrad = AppColors.heroGradient;
const _collabGrads = [
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF8A4C), Color(0xFFE2365B)],
  ),
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4E9A73), Color(0xFF3C7D5C)],
  ),
  _ownerGrad,
];

/// Co-planning: invite people to a trip with a role (prototype `Profile.jsx` →
/// Collaborators). Phase 1 — owner manages an invite list (the invited person
/// doesn't gain live trip access yet). Reached from the Trip Hub.
class CollaboratorsScreen extends ConsumerWidget {
  const CollaboratorsScreen({super.key, required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    ref.watch(collaboratorsSyncProvider(tripId));
    final trip = ref.watch(tripDetailProvider(tripId)).asData?.value;
    final profile = ref.watch(profileProvider);
    // Only the account that created the trip owns it. Anyone else on this
    // screen is an invited collaborator and must not be shown as the owner.
    final isOwner =
        trip?.userId == null ||
        profile.userId == null ||
        trip!.userId == profile.userId;
    final people =
        ref.watch(collaboratorsProvider(tripId)).asData?.value ??
        const <Collaborator>[];

    final active = people
        .where((c) => c.status == CollaboratorStatus.active)
        .toList();
    final pending = people
        .where((c) => c.status == CollaboratorStatus.pending)
        .toList();
    final code = tripId.length > 6
        ? tripId.substring(tripId.length - 6)
        : tripId;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              title: l10n.collaboratorsTitle,
              sub: trip?.title,
              onInvite: isOwner ? () => _openInvite(context, ref) : null,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  0,
                  AppSpacing.screen,
                  24,
                ),
                children: [
                  _InviteLinkCard(code: code),
                  const SizedBox(height: 18),
                  _Eyebrow(l10n.collabPeopleCount(active.length + 1)),
                  VentusCard(
                    children: [
                      _OwnerRow(profile: isOwner ? profile : null),
                      for (var i = 0; i < active.length; i++)
                        _CollaboratorRow(
                          collaborator: active[i],
                          grad: _collabGrads[i % _collabGrads.length],
                          last: i == active.length - 1,
                          isYou: _isSameEmail(active[i].email, profile.email),
                          onManage: isOwner
                              ? () => _manage(context, ref, active[i])
                              : null,
                        ),
                    ],
                  ),
                  if (pending.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _Eyebrow(l10n.collabPending),
                    VentusCard(
                      children: [
                        for (var i = 0; i < pending.length; i++)
                          _PendingRow(
                            collaborator: pending[i],
                            last: i == pending.length - 1,
                            onManage: isOwner
                                ? () => _manage(context, ref, pending[i])
                                : null,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openInvite(BuildContext context, WidgetRef ref) async {
    await showVentusSheet<void>(
      context,
      builder: (_) => _InviteSheet(tripId: tripId),
    );
  }

  Future<void> _manage(
    BuildContext context,
    WidgetRef ref,
    Collaborator c,
  ) async {
    final l10n = context.l10n;
    final action = await showVentusSheet<_ManageAction>(
      context,
      isScrollControlled: false,
      builder: (_) => _ManageSheet(current: c.role),
    );
    if (action == null || !context.mounted) return;
    final controller = ref.read(collaboratorsControllerProvider.notifier);
    switch (action) {
      case _ManageAction.editor:
        await controller.changeRole(c, CollaboratorRole.editor);
      case _ManageAction.viewer:
        await controller.changeRole(c, CollaboratorRole.viewer);
      case _ManageAction.remove:
        await controller.remove(c.id);
        if (!context.mounted) return;
        showVentusSuccess(context, l10n.collabRemoved);
    }
  }
}

/// Localized label for a collaborator role.
String roleLabel(BuildContext context, CollaboratorRole role) => switch (role) {
  CollaboratorRole.editor => context.l10n.roleEditor,
  CollaboratorRole.viewer => context.l10n.roleViewer,
};

String _initialsFor(String? name, String email) {
  final source = (name != null && name.trim().isNotEmpty) ? name.trim() : email;
  final parts = source.split(RegExp(r'[\s@.]+')).where((p) => p.isNotEmpty);
  if (parts.isEmpty) return '?';
  return parts.take(2).map((p) => p[0]).join().toUpperCase();
}

class _Header extends StatelessWidget {
  const _Header({required this.title, this.sub, this.onInvite});

  final String title;
  final String? sub;

  /// Null hides the "+" button (collaborators cannot invite others).
  final VoidCallback? onInvite;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        6,
        AppSpacing.screen,
        12,
      ),
      child: Row(
        children: [
          VentusTap(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
                boxShadow: context.shadows.card,
              ),
              child: VentusIcon(
                VentusIcons.arrowLeft,
                size: 20,
                color: colors.ink,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSize.h3,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: colors.ink,
                  ),
                ),
                if (sub != null && sub!.isNotEmpty)
                  Text(
                    sub!,
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
          if (onInvite != null) ...[
            const SizedBox(width: 12),
            VentusAddButton(onTap: onInvite!),
          ],
        ],
      ),
    );
  }
}

class _InviteLinkCard extends StatelessWidget {
  const _InviteLinkCard({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final link = 'ventus.app/t/$code';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.primarySoft,
        borderRadius: AppRadius.brLg,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: AppRadius.brSm,
            ),
            child: VentusIcon(
              VentusIcons.link,
              size: 19,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.collabAnyoneWithLink,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w700,
                    color: colors.ink,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  link,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSize.caption,
                    fontWeight: FontWeight.w600,
                    color: context.primaryFill,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          VentusTap(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: 'https://$link'));
              if (!context.mounted) return;
              showVentusSuccess(context, l10n.collabLinkCopied);
            },
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: AppRadius.brFull,
              ),
              child: Row(
                children: [
                  const VentusIcon(
                    VentusIcons.copy,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.collabCopy,
                    style: const TextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: AppFontSize.eyebrow,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: colors.muted,
        ),
      ),
    );
  }
}

bool _isSameEmail(String a, String b) =>
    a.trim().toLowerCase() == b.trim().toLowerCase();

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials, required this.grad, this.icon});

  final String initials;
  final Gradient grad;

  /// Shown instead of [initials] when the person's name is not known.
  final String? icon;
  static const double size = 42;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(gradient: grad, shape: BoxShape.circle),
      child: icon != null
          ? VentusIcon(icon!, size: size * 0.5, color: Colors.white)
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

/// The trip owner. [profile] is the signed-in user when they own the trip, and
/// null otherwise — the owner's name and email are not available to a
/// collaborator, so a generic row stands in instead of mislabelling the viewer.
class _OwnerRow extends StatelessWidget {
  const _OwnerRow({required this.profile});

  final ProfileInfo? profile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final owner = profile;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          owner != null
              ? _Avatar(initials: owner.initials, grad: _ownerGrad)
              : const _Avatar(
                  initials: '',
                  grad: _ownerGrad,
                  icon: VentusIcons.user,
                ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: owner?.name ?? l10n.collabTripOwner,
                        style: TextStyle(
                          fontSize: AppFontSize.sm,
                          fontWeight: FontWeight.w700,
                          color: colors.ink,
                        ),
                      ),
                      if (owner != null)
                        TextSpan(
                          text: ' · ${l10n.collabYou}',
                          style: TextStyle(
                            fontSize: AppFontSize.sm,
                            fontWeight: FontWeight.w600,
                            color: colors.muted,
                          ),
                        ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (owner != null && owner.email.isNotEmpty)
                  Text(
                    owner.email,
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
          const SizedBox(width: 10),
          VentusBadge(label: l10n.roleOwner, tone: VentusBadgeTone.primary),
        ],
      ),
    );
  }
}

class _CollaboratorRow extends StatelessWidget {
  const _CollaboratorRow({
    required this.collaborator,
    required this.grad,
    required this.last,
    required this.isYou,
    required this.onManage,
  });

  final Collaborator collaborator;
  final Gradient grad;
  final bool last;

  /// This collaborator is the signed-in user.
  final bool isYou;

  /// Null when the viewer may not change roles (only the owner can).
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = (collaborator.name != null && collaborator.name!.isNotEmpty)
        ? collaborator.name!
        : collaborator.email;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          _Avatar(
            initials: _initialsFor(collaborator.name, collaborator.email),
            grad: grad,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: name,
                        style: TextStyle(
                          fontSize: AppFontSize.sm,
                          fontWeight: FontWeight.w700,
                          color: colors.ink,
                        ),
                      ),
                      if (isYou)
                        TextSpan(
                          text: ' · ${context.l10n.collabYou}',
                          style: TextStyle(
                            fontSize: AppFontSize.sm,
                            fontWeight: FontWeight.w600,
                            color: colors.muted,
                          ),
                        ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  collaborator.email,
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
          const SizedBox(width: 10),
          _RoleChip(role: collaborator.role, onTap: onManage),
        ],
      ),
    );
  }
}

class _PendingRow extends StatelessWidget {
  const _PendingRow({
    required this.collaborator,
    required this.last,
    required this.onManage,
  });

  final Collaborator collaborator;
  final bool last;
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surfaceSand,
              shape: BoxShape.circle,
            ),
            child: VentusIcon(VentusIcons.mail, size: 18, color: colors.muted),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collaborator.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w700,
                    color: colors.ink,
                  ),
                ),
                Text(
                  '${roleLabel(context, collaborator.role)} · ${l10n.collabInviteSent}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSize.caption,
                    fontWeight: FontWeight.w600,
                    color: colors.amber,
                  ),
                ),
              ],
            ),
          ),
          VentusTap(
            onTap: onManage,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: VentusIcon(
                VentusIcons.more,
                size: 18,
                color: colors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.role, required this.onTap});

  final CollaboratorRole role;

  /// Null makes the chip a plain label (no chevron, not tappable).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brFull,
          boxShadow: context.shadows.card,
        ),
        child: Row(
          children: [
            Text(
              roleLabel(context, role),
              style: TextStyle(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w700,
                color: colors.ink2,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 5),
              VentusIcon(
                VentusIcons.chevronDown,
                size: 14,
                color: colors.muted,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum _ManageAction { editor, viewer, remove }

class _ManageSheet extends StatelessWidget {
  const _ManageSheet({required this.current});

  final CollaboratorRole current;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VentusSheetHandle(),
            _ManageOption(
              icon: VentusIcons.check,
              label: l10n.roleEditor,
              selected: current == CollaboratorRole.editor,
              onTap: () => Navigator.of(context).pop(_ManageAction.editor),
            ),
            _ManageOption(
              icon: VentusIcons.check,
              label: l10n.roleViewer,
              selected: current == CollaboratorRole.viewer,
              onTap: () => Navigator.of(context).pop(_ManageAction.viewer),
            ),
            _ManageOption(
              icon: VentusIcons.trash,
              label: l10n.removeCollaborator,
              danger: true,
              onTap: () => Navigator.of(context).pop(_ManageAction.remove),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManageOption extends StatelessWidget {
  const _ManageOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.danger = false,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = danger ? colors.danger : colors.ink;
    return VentusTap(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: AppFontSize.body,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ),
            if (selected && !danger)
              VentusIcon(icon, size: 20, color: colors.primary)
            else if (danger)
              VentusIcon(icon, size: 19, color: colors.danger),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet: enter an email + pick a role, then send the invite.
class _InviteSheet extends ConsumerStatefulWidget {
  const _InviteSheet({required this.tripId});

  final String tripId;

  @override
  ConsumerState<_InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends ConsumerState<_InviteSheet> {
  final _email = TextEditingController();
  CollaboratorRole _role = CollaboratorRole.editor;
  bool _error = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final saving = ref.watch(collaboratorsControllerProvider).isLoading;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          10,
          AppSpacing.screen,
          24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: colors.lineStrong,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Text(
              l10n.inviteTitle,
              style: TextStyle(
                fontSize: AppFontSize.body,
                fontWeight: FontWeight.w700,
                color: colors.ink,
              ),
            ),
            const SizedBox(height: 14),
            VentusTextField(
              label: l10n.emailLabel,
              hintText: l10n.emailHint,
              controller: _email,
              icon: VentusIcons.mail,
              keyboardType: TextInputType.emailAddress,
              errorText: _error ? l10n.inviteEmailInvalid : null,
              onChanged: (_) {
                if (_error) setState(() => _error = false);
              },
            ),
            const SizedBox(height: 16),
            Text(
              l10n.inviteRoleLabel,
              style: TextStyle(
                fontSize: AppFontSize.eyebrow,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: colors.muted,
              ),
            ),
            const SizedBox(height: 9),
            _RoleOption(
              label: l10n.roleEditor,
              desc: l10n.roleEditorDesc,
              selected: _role == CollaboratorRole.editor,
              onTap: () => setState(() => _role = CollaboratorRole.editor),
            ),
            const SizedBox(height: 10),
            _RoleOption(
              label: l10n.roleViewer,
              desc: l10n.roleViewerDesc,
              selected: _role == CollaboratorRole.viewer,
              onTap: () => setState(() => _role = CollaboratorRole.viewer),
            ),
            const SizedBox(height: 20),
            VentusButton(
              label: l10n.sendInvite,
              iconLeft: VentusIcons.mail,
              full: true,
              loading: saving,
              onPressed: saving ? null : _send,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _send() async {
    final email = _email.text.trim();
    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _error = true);
      return;
    }
    final navigator = Navigator.of(context);
    final l10n = context.l10n;
    final ok = await ref
        .read(collaboratorsControllerProvider.notifier)
        .invite(tripId: widget.tripId, email: email, role: _role);
    if (!mounted) return;
    if (ok) {
      showVentusSuccess(context, l10n.collabInviteSentToast);
      navigator.pop();
    } else {
      showVentusError(context, l10n.somethingWentWrong, onRetry: _send);
    }
  }
}

class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.label,
    required this.desc,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String desc;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: selected ? colors.primarySoft : colors.surface,
          borderRadius: AppRadius.brMd,
          border: Border.all(
            color: selected ? colors.primary : colors.lineStrong,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? colors.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? colors.primary : colors.lineStrong,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const VentusIcon(
                      VentusIcons.check,
                      size: 13,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w700,
                      color: colors.ink,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: AppFontSize.caption,
                      color: colors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
