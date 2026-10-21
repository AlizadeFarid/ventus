import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';
import '../screens/trip_detail_screen.dart' show HubTab;

/// What a trip needs next, in the order a traveller usually tackles it.
enum TripNextStep { plan, checklist, budget, documents, done }

/// Picks the single most useful next step for a trip, or null when there is
/// nothing worth nudging (it is partly planned and the basics are in place).
TripNextStep? nextStepFor({
  required int plannedPercent,
  required int checklistCount,
  required bool hasBudget,
  required int documentsCount,
}) {
  if (plannedPercent == 0) return TripNextStep.plan;
  if (checklistCount == 0) return TripNextStep.checklist;
  if (!hasBudget) return TripNextStep.budget;
  if (documentsCount == 0) return TripNextStep.documents;
  if (plannedPercent >= 100) return TripNextStep.done;
  return null;
}

/// One highlighted suggestion on Home: the next thing to do for the featured
/// trip. Replaces four equal-weight shortcuts with a single clear action; when
/// everything is in place and every day is planned it turns into a small
/// celebration.
class TripNextStepCard extends StatelessWidget {
  const TripNextStepCard({super.key, required this.step, required this.onOpen});

  final TripNextStep step;

  /// Opens the hub tab the step points at.
  final ValueChanged<HubTab> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    final (icon, title, body, tab) = switch (step) {
      TripNextStep.plan => (
        VentusIcons.route,
        l10n.nextStepPlanTitle,
        l10n.nextStepPlanBody,
        HubTab.itinerary,
      ),
      TripNextStep.checklist => (
        VentusIcons.listCheck,
        l10n.nextStepChecklistTitle,
        l10n.nextStepChecklistBody,
        HubTab.checklist,
      ),
      TripNextStep.budget => (
        VentusIcons.wallet,
        l10n.nextStepBudgetTitle,
        l10n.nextStepBudgetBody,
        HubTab.budget,
      ),
      TripNextStep.documents => (
        VentusIcons.document,
        l10n.nextStepDocsTitle,
        l10n.nextStepDocsBody,
        HubTab.documents,
      ),
      TripNextStep.done => (
        VentusIcons.sparkle,
        l10n.planCompleteTitle,
        l10n.planCompleteBody,
        HubTab.overview,
      ),
    };
    final isDone = step == TripNextStep.done;

    if (!isDone) {
      // One tinted line: icon, the action, a chevron. The explanatory body and
      // the eyebrow are dropped (the title already says what to do) so the card
      // stays well below the weight of the hero above it.
      return VentusTap(
        onTap: () => onOpen(tab),
        semanticLabel: '$title. $body',
        child: Container(
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: colors.primarySoft,
            borderRadius: AppRadius.brLg,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                ),
                child: VentusIcon(icon, size: 18, color: colors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typography.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              VentusIcon(
                VentusIcons.chevronRight,
                size: 18,
                color: context.primaryFill,
              ),
            ],
          ),
        ),
      );
    }

    final card = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.brLg,
        boxShadow: context.shadows.raised,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primarySoft,
              borderRadius: AppRadius.brMd,
            ),
            child: VentusIcon(icon, size: 22, color: colors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typography.h3.copyWith(color: colors.ink),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.typography.sm.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return VentusTap(
      onTap: () => onOpen(tab),
      child: VentusConfetti(
        colors: [colors.primary, colors.amber, colors.primarySoft],
        child: card,
      ),
    );
  }
}
