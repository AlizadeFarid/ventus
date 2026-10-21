import 'package:flutter/material.dart';
import '../../../../core/theme/app_overlay.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Billing period shown on the paywall.
enum _Plan { yearly, monthly }

/// Ventus Pro paywall — variant A (full paywall with plan cards), from
/// `Pro.jsx` → ProPaywall. Reached from the Profile hub's Pro banner.
///
/// There is no billing infrastructure yet, so the CTA is honest: it surfaces a
/// "coming soon" message rather than pretending to start a purchase. The
/// billing toggle is fully interactive so the layout can be reviewed for real.
class ProScreen extends StatefulWidget {
  const ProScreen({super.key});

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  _Plan _plan = _Plan.yearly;

  void _select(_Plan plan) => setState(() => _plan = plan);

  void _comingSoon() {
    showVentusSnack(context, context.l10n.proComingSoon);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.bg,
      body: Column(
        children: [
          _Hero(onClose: () => context.pop()),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                18,
                AppSpacing.screen,
                18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _PlanCard(
                          selected: _plan == _Plan.yearly,
                          title: l10n.proBillingYearly,
                          price: r'$41.99',
                          period: l10n.proPerYear,
                          note: l10n.proYearlyEquiv,
                          badge: l10n.proSave,
                          onTap: () => _select(_Plan.yearly),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _PlanCard(
                          selected: _plan == _Plan.monthly,
                          title: l10n.proBillingMonthly,
                          price: r'$4.99',
                          period: l10n.proPerMonth,
                          note: l10n.proBilledMonthly,
                          onTap: () => _select(_Plan.monthly),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const _Comparison(),
                ],
              ),
            ),
          ),
          _Cta(
            label: l10n.proCtaTrial,
            note: _plan == _Plan.yearly
                ? l10n.proThenYearly
                : l10n.proThenMonthly,
            onTap: _comingSoon,
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(gradient: context.colors.gradientHero),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        8,
        AppSpacing.screen,
        26,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VentusTap(
              onTap: onClose,
              child: Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppOverlay.glassFill,
                  shape: BoxShape.circle,
                ),
                child: const VentusIcon(
                  VentusIcons.close,
                  size: 19,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppOverlay.glassFill,
                    borderRadius: AppRadius.brSm,
                  ),
                  child: const VentusIcon(
                    VentusIcons.crown,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.proTitle,
                      style: const TextStyle(
                        fontSize: AppFontSize.h2,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.proTagline,
                      style: const TextStyle(
                        fontSize: AppFontSize.sm,
                        color: AppOverlay.onPhotoStrong,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.selected,
    required this.title,
    required this.price,
    required this.period,
    required this.note,
    required this.onTap,
    this.badge,
  });

  final bool selected;
  final String title;
  final String price;
  final String period;
  final String note;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: selected ? colors.primarySoft : colors.surface,
              borderRadius: AppRadius.brLg,
              border: Border.all(
                color: selected ? colors.primary : colors.lineStrong,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w700,
                    color: colors.ink2,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: price,
                    style: TextStyle(
                      fontSize: AppFontSize.h3,
                      fontWeight: FontWeight.w700,
                      color: colors.ink,
                    ),
                    children: [
                      TextSpan(
                        text: period,
                        style: TextStyle(
                          fontSize: AppFontSize.caption,
                          fontWeight: FontWeight.w600,
                          color: colors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  note,
                  style: TextStyle(
                    fontSize: AppFontSize.eyebrow,
                    fontWeight: FontWeight.w600,
                    color: colors.muted,
                  ),
                ),
              ],
            ),
          ),
          if (badge != null)
            Positioned(
              top: -10,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.success,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badge!.toUpperCase(),
                  style: const TextStyle(
                    fontSize: AppFontSize.eyebrow,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Comparison extends StatelessWidget {
  const _Comparison();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.brLg,
        boxShadow: context.shadows.card,
      ),
      child: Column(
        children: [
          // header
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 8),
            child: Row(
              children: [
                Expanded(child: _Eyebrow(l10n.proColFeature)),
                SizedBox(
                  width: 70,
                  child: Center(child: _Eyebrow(l10n.proColFree)),
                ),
                SizedBox(
                  width: 70,
                  child: Center(
                    child: _Eyebrow(l10n.proColPro, color: colors.primary),
                  ),
                ),
              ],
            ),
          ),
          _CmpRow(label: l10n.proRowTrips, free: '3', pro: '∞'),
          _CmpRow(
            label: l10n.proRowAiPlans,
            free: l10n.proFreeAiPlansPerMonth,
            pro: '∞',
          ),
          _CmpRow(label: l10n.proRowOfflineMaps, freeYes: false, proYes: true),
          _CmpRow(
            label: l10n.proRowCollaborators,
            freeYes: false,
            proYes: true,
          ),
          _CmpRow(
            label: l10n.proRowVault,
            free: '1 GB',
            pro: '20 GB',
            last: true,
          ),
        ],
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text, {this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: AppFontSize.eyebrow,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: color ?? context.colors.muted,
      ),
    );
  }
}

/// A comparison row. Either pass [free]/[pro] text, or [freeYes]/[proYes] to
/// render a check (or a dash for a missing free feature).
class _CmpRow extends StatelessWidget {
  const _CmpRow({
    required this.label,
    this.free,
    this.pro,
    this.freeYes,
    this.proYes,
    this.last = false,
  });

  final String label;
  final String? free;
  final String? pro;
  final bool? freeYes;
  final bool? proYes;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w600,
                color: colors.ink2,
              ),
            ),
          ),
          SizedBox(width: 70, child: Center(child: _freeCell(colors))),
          SizedBox(width: 70, child: Center(child: _proCell(colors))),
        ],
      ),
    );
  }

  Widget _freeCell(AppColors colors) {
    if (freeYes == true) {
      return VentusIcon(VentusIcons.check, size: 17, color: colors.muted);
    }
    if (freeYes == false) {
      return Text(
        '—',
        style: TextStyle(
          fontSize: AppFontSize.sm,
          fontWeight: FontWeight.w700,
          color: colors.lineStrong,
        ),
      );
    }
    return Text(
      free ?? '',
      style: TextStyle(
        fontSize: AppFontSize.sm,
        fontWeight: FontWeight.w700,
        color: colors.muted,
      ),
    );
  }

  Widget _proCell(AppColors colors) {
    if (proYes == true) {
      return VentusIcon(VentusIcons.check, size: 17, color: colors.primary);
    }
    return Text(
      pro ?? '',
      style: TextStyle(
        fontSize: AppFontSize.sm,
        fontWeight: FontWeight.w700,
        color: colors.primary,
      ),
    );
  }
}

class _Cta extends StatelessWidget {
  const _Cta({required this.label, required this.note, required this.onTap});

  final String label;
  final String note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bg,
        boxShadow: context.shadows.bar,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            14,
            AppSpacing.screen,
            16,
          ),
          child: Column(
            children: [
              VentusButton(
                label: label,
                full: true,
                iconLeft: VentusIcons.crown,
                onPressed: onTap,
              ),
              const SizedBox(height: 10),
              Text(
                note,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSize.caption,
                  color: colors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
