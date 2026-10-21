import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/config/feature_flags.dart';
import '../../../../../../core/extensions/theme_context_extension.dart';
import '../../../../../../core/l10n/l10n_extension.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../shared/widgets/widgets.dart';
import '../../../../application/create_trip_controller.dart';
import '../../../../domain/traveler_type.dart';
import '../create_chrome.dart';
import '../../../../../../core/theme/app_typography.dart';
import '../../../../../../core/theme/app_spacing.dart';

/// Step 2 — who's coming: traveler type plus adult/child counts.
class TravelersStep extends ConsumerWidget {
  const TravelersStep({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  final VoidCallback onContinue;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(createTripControllerProvider);
    final controller = ref.read(createTripControllerProvider.notifier);

    final types = <(TravelerType, String, String)>[
      (TravelerType.solo, VentusIcons.user, l10n.travelerSolo),
      (TravelerType.couple, VentusIcons.heart, l10n.travelerCouple),
      (TravelerType.family, VentusIcons.home, l10n.travelerFamily),
      (TravelerType.friends, VentusIcons.share, l10n.travelerFriends),
    ];

    return CreateStepScaffold(
      header: CreateStepHeader(step: 2, onLead: onBack),
      footer: VentusButton(
        label: l10n.continueAction,
        full: true,
        iconRight: VentusIcons.arrowRight,
        onPressed: onContinue,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreateStepTitle(
              title: l10n.whosComing,
              subtitle: l10n.travelersSubtitle,
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final (type, icon, label) in types)
                  VentusChip(
                    label: label,
                    icon: icon,
                    active: state.travelerType == type,
                    onTap: () => controller.setTravelerType(type),
                  ),
              ],
            ),
            const SizedBox(height: 26),
            _Stepper(
              icon: VentusIcons.user,
              label: l10n.travelersAdults,
              sub: l10n.travelersAdultsSub,
              value: state.adults,
              minValue: 1,
              onChanged: controller.setAdults,
            ),
            const SizedBox(height: 12),
            _Stepper(
              icon: VentusIcons.heart,
              label: l10n.travelersChildren,
              sub: l10n.travelersChildrenSub,
              value: state.children,
              minValue: 0,
              onChanged: controller.setChildren,
            ),
            if (AppFeatures.collaborators) ...[
              const SizedBox(height: 18),
              _InviteRow(
                count: state.invites.length,
                onTap: () => _openInviteSheet(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _openInviteSheet(BuildContext context) {
    return showVentusSheet<void>(context, builder: (_) => const _InviteSheet());
  }
}

/// Bottom sheet that collects companion emails into the draft. They become
/// pending collaborators once the trip is saved (see review step).
class _InviteSheet extends ConsumerStatefulWidget {
  const _InviteSheet();

  @override
  ConsumerState<_InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends ConsumerState<_InviteSheet> {
  final TextEditingController _email = TextEditingController();
  bool _invalid = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _add() {
    final value = _email.text.trim();
    if (Validators.email(value) != null) {
      setState(() => _invalid = true);
      return;
    }
    ref.read(createTripControllerProvider.notifier).addInvite(value);
    _email.clear();
    setState(() => _invalid = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final invites = ref.watch(
      createTripControllerProvider.select((s) => s.invites),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        14,
        AppSpacing.screen,
        MediaQuery.of(context).viewInsets.bottom + 22,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.lineStrong,
                borderRadius: AppRadius.brFull,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.inviteCompanions,
            style: context.typography.h3.copyWith(color: colors.ink),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.inviteAfterCreate,
            style: TextStyle(fontSize: AppFontSize.sm, color: colors.muted),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: VentusTextField(
                  controller: _email,
                  hintText: l10n.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _invalid ? l10n.inviteEmailInvalid : null,
                  onSubmitted: (_) => _add(),
                ),
              ),
              const SizedBox(width: 10),
              VentusButton(
                label: l10n.inviteAdd,
                size: VentusButtonSize.md,
                onPressed: _add,
              ),
            ],
          ),
          if (invites.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final email in invites)
                  _EmailChip(
                    email: email,
                    onRemove: () => ref
                        .read(createTripControllerProvider.notifier)
                        .removeInvite(email),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// A removable email pill in the invite sheet.
class _EmailChip extends StatelessWidget {
  const _EmailChip({required this.email, required this.onRemove});

  final String email;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: colors.primarySoft,
        borderRadius: AppRadius.brFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            email,
            style: TextStyle(
              fontSize: AppFontSize.sm,
              fontWeight: FontWeight.w600,
              color: context.primaryFill,
            ),
          ),
          const SizedBox(width: 6),
          VentusTap(
            onTap: onRemove,
            child: VentusIcon(
              VentusIcons.close,
              size: 16,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Labeled count stepper with − / + controls.
class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.icon,
    required this.label,
    required this.sub,
    required this.value,
    required this.minValue,
    required this.onChanged,
  });

  final String icon;
  final String label;
  final String sub;
  final int value;
  final int minValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final canDec = value > minValue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.brLg,
        boxShadow: context.shadows.card,
      ),
      child: Row(
        children: [
          VentusLeadIcon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppFontSize.body,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  sub,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    color: colors.muted,
                  ),
                ),
              ],
            ),
          ),
          _RoundStep(
            filled: false,
            enabled: canDec,
            onTap: canDec ? () => onChanged(value - 1) : null,
            child: VentusIcon(VentusIcons.minus, size: 16, color: colors.ink),
          ),
          SizedBox(
            width: 38,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSize.h3,
                fontWeight: FontWeight.w700,
                color: colors.ink,
              ),
            ),
          ),
          _RoundStep(
            filled: true,
            enabled: true,
            onTap: () => onChanged(value + 1),
            child: VentusIcon(
              VentusIcons.plus,
              size: 16,
              color: colors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundStep extends StatelessWidget {
  const _RoundStep({
    required this.filled,
    required this.enabled,
    required this.onTap,
    required this.child,
  });

  final bool filled;
  final bool enabled;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: filled ? colors.primary : colors.surface,
            shape: BoxShape.circle,
            boxShadow: context.shadows.card,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Optional "invite companions" affordance — opens the email-collecting sheet.
/// Shows how many companions are queued so far.
class _InviteRow extends StatelessWidget {
  const _InviteRow({required this.onTap, required this.count});

  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final hasInvites = count > 0;
    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surfaceSand,
          borderRadius: AppRadius.brMd,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.primarySoft,
                borderRadius: AppRadius.brSm,
              ),
              child: VentusIcon(
                VentusIcons.mail,
                size: 18,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.inviteCompanions,
                    style: TextStyle(
                      fontSize: AppFontSize.body,
                      fontWeight: FontWeight.w600,
                      color: colors.ink,
                    ),
                  ),
                  Text(
                    hasInvites
                        ? l10n.collabPeopleCount(count)
                        : l10n.inviteCompanionsSub,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      color: hasInvites ? colors.primary : colors.muted,
                      fontWeight: hasInvites
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            VentusIcon(VentusIcons.chevronRight, size: 18, color: colors.muted),
          ],
        ),
      ),
    );
  }
}
