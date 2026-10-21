import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/theme_mode_provider.dart';
import '../../shared/widgets/widgets.dart';

/// Developer-only visual catalogue of the design system (tokens + components).
///
/// Not part of the product UI — wired to the home route only during the
/// foundation phase so the design system can be eyeballed against the
/// prototype, in both light and dark.
class DesignGalleryScreen extends ConsumerStatefulWidget {
  const DesignGalleryScreen({super.key});

  @override
  ConsumerState<DesignGalleryScreen> createState() =>
      _DesignGalleryScreenState();
}

enum _View { tokens, components }

class _DesignGalleryScreenState extends ConsumerState<DesignGalleryScreen> {
  _View _view = _View.tokens;

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System'),
        actions: [
          TextButton.icon(
            onPressed: () => ref.read(themeModeProvider.notifier).cycle(),
            icon: Icon(switch (mode) {
              ThemeMode.system => Icons.brightness_auto_outlined,
              ThemeMode.light => Icons.light_mode_outlined,
              ThemeMode.dark => Icons.dark_mode_outlined,
            }),
            label: Text(mode.name),
          ),
          const SizedBox(width: AppSpacing.s2),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s3),
            child: VentusSegmentedControl<_View>(
              value: _view,
              onChanged: (v) => setState(() => _view = v),
              segments: const [
                (value: _View.tokens, label: 'Tokens'),
                (value: _View.components, label: 'Components'),
              ],
            ),
          ),
          Expanded(
            child: _view == _View.tokens
                ? const _TokensView()
                : const _ComponentsView(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── Tokens ───────────────────────────────

class _TokensView extends StatelessWidget {
  const _TokensView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s5),
      children: [
        _Section(
          title: 'Colors',
          child: Wrap(
            spacing: AppSpacing.s3,
            runSpacing: AppSpacing.s3,
            children: [
              _Swatch('bg', colors.bg),
              _Swatch('surface', colors.surface),
              _Swatch('surfaceSand', colors.surfaceSand),
              _Swatch('ink', colors.ink),
              _Swatch('ink2', colors.ink2),
              _Swatch('muted', colors.muted),
              _Swatch('line', colors.line),
              _Swatch('lineStrong', colors.lineStrong),
              _Swatch('primary', colors.primary),
              _Swatch('primaryPress', colors.primaryPress),
              _Swatch('primarySoft', colors.primarySoft),
              _Swatch('sea', colors.sea),
              _Swatch('seaSoft', colors.seaSoft),
              _Swatch('amber', colors.amber),
              _Swatch('success', colors.success),
              _Swatch('successSoft', colors.successSoft),
              _Swatch('danger', colors.danger),
              _Swatch('dangerSoft', colors.dangerSoft),
            ],
          ),
        ),
        _Section(
          title: 'Typography',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Display 32', style: type.display),
              const SizedBox(height: AppSpacing.s2),
              Text('Heading 1 · 26', style: type.h1),
              const SizedBox(height: AppSpacing.s2),
              Text('Heading 2 · 22', style: type.h2),
              const SizedBox(height: AppSpacing.s2),
              Text('Heading 3 · 18', style: type.h3),
              const SizedBox(height: AppSpacing.s2),
              Text('Body · 16 — The quick brown fox.', style: type.body),
              const SizedBox(height: AppSpacing.s2),
              Text('Small · 14', style: type.sm.copyWith(color: colors.ink2)),
              const SizedBox(height: AppSpacing.s2),
              Text(
                'Caption · 13',
                style: type.caption.copyWith(color: colors.muted),
              ),
              const SizedBox(height: AppSpacing.s3),
              Text(
                'EYEBROW · WIDE',
                style: type.eyebrow.copyWith(color: colors.muted),
              ),
            ],
          ),
        ),
        _Section(
          title: 'Radius',
          child: Wrap(
            spacing: AppSpacing.s3,
            runSpacing: AppSpacing.s3,
            children: const [
              _RadiusBox('sm', AppRadius.sm),
              _RadiusBox('md', AppRadius.md),
              _RadiusBox('lg', AppRadius.lg),
              _RadiusBox('xl', AppRadius.xl),
            ],
          ),
        ),
        _Section(
          title: 'Shadows',
          child: Wrap(
            spacing: AppSpacing.s6,
            runSpacing: AppSpacing.s6,
            children: [
              _ShadowBox('sm', context.shadows.sm),
              _ShadowBox('card', context.shadows.card),
              _ShadowBox('pop', context.shadows.pop),
            ],
          ),
        ),
      ],
    );
  }
}

// ───────────────────────────── Components ─────────────────────────────

class _ComponentsView extends StatefulWidget {
  const _ComponentsView();

  @override
  State<_ComponentsView> createState() => _ComponentsViewState();
}

class _ComponentsViewState extends State<_ComponentsView> {
  bool _checked = true;
  bool _toggled = true;
  String _chip = 'all';
  String _seg = 'overview';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s5),
      children: [
        const _Section(
          title: 'Logo',
          child: Row(
            children: [
              VentusLogo(size: 26),
              SizedBox(width: AppSpacing.s6),
              VentusMark(size: 40),
            ],
          ),
        ),
        _Section(
          title: 'Buttons',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VentusButton(
                label: 'Primary',
                iconLeft: VentusIcons.sparkle,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.s3),
              VentusButton(
                label: 'Secondary',
                variant: VentusButtonVariant.secondary,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.s3),
              Row(
                children: [
                  VentusButton(
                    label: 'Ghost',
                    variant: VentusButtonVariant.ghost,
                    size: VentusButtonSize.md,
                    onPressed: () {},
                  ),
                  const SizedBox(width: AppSpacing.s3),
                  VentusButton(
                    label: 'Danger',
                    variant: VentusButtonVariant.danger,
                    size: VentusButtonSize.md,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s3),
              VentusButton(
                label: 'Continue with Google',
                variant: VentusButtonVariant.social,
                iconLeft: VentusIcons.google,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.s3),
              VentusButton(
                label: _loading ? 'Loading…' : 'Tap to load',
                loading: _loading,
                onPressed: () async {
                  setState(() => _loading = true);
                  await Future<void>.delayed(const Duration(seconds: 1));
                  if (mounted) setState(() => _loading = false);
                },
              ),
            ],
          ),
        ),
        _Section(
          title: 'Inputs',
          child: Column(
            children: [
              const VentusTextField(
                label: 'Email',
                hintText: 'you@example.com',
                icon: VentusIcons.mail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.s4),
              const VentusTextField(
                label: 'Password',
                hintText: '••••••••',
                icon: VentusIcons.lock,
                obscure: true,
                helper: 'At least 8 characters',
              ),
              const SizedBox(height: AppSpacing.s4),
              const VentusTextField(
                label: 'Trip name',
                hintText: 'Summer in Lisbon',
                errorText: 'This field is required',
              ),
              const SizedBox(height: AppSpacing.s5),
              Align(
                alignment: Alignment.center,
                child: VentusPinInput(onChanged: (_) {}),
              ),
            ],
          ),
        ),
        _Section(
          title: 'Chips',
          child: Wrap(
            spacing: AppSpacing.s2,
            runSpacing: AppSpacing.s2,
            children: [
              for (final c in const ['all', 'tickets', 'stays', 'identity'])
                VentusChip(
                  label: c[0].toUpperCase() + c.substring(1),
                  icon: c == 'all' ? VentusIcons.grid : null,
                  active: _chip == c,
                  onTap: () => setState(() => _chip = c),
                ),
            ],
          ),
        ),
        const _Section(
          title: 'Badges',
          child: Wrap(
            spacing: AppSpacing.s2,
            runSpacing: AppSpacing.s2,
            children: [
              VentusBadge(label: 'Neutral'),
              VentusBadge(label: 'Primary', tone: VentusBadgeTone.primary),
              VentusBadge(label: 'Sea', tone: VentusBadgeTone.sea),
              VentusBadge(label: 'Booked', tone: VentusBadgeTone.success),
              VentusBadge(label: '4.8', tone: VentusBadgeTone.amber),
            ],
          ),
        ),
        _Section(
          title: 'Selection',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VentusCheckbox(
                value: _checked,
                label: 'Remember this device',
                onChanged: (v) => setState(() => _checked = v),
              ),
              const SizedBox(height: AppSpacing.s4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: context.typography.body.copyWith(color: colors.ink2),
                  ),
                  VentusToggle(
                    value: _toggled,
                    onChanged: (v) => setState(() => _toggled = v),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s4),
              VentusSegmentedControl<String>(
                value: _seg,
                onChanged: (v) => setState(() => _seg = v),
                segments: const [
                  (value: 'overview', label: 'Overview'),
                  (value: 'daily', label: 'Daily'),
                  (value: 'compare', label: 'Compare'),
                ],
              ),
            ],
          ),
        ),
        const _Section(
          title: 'Divider',
          child: VentusDivider(label: 'or continue with'),
        ),
        _Section(
          title: 'Add & search',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  VentusAddButton(onTap: () {}),
                  const SizedBox(width: AppSpacing.s4),
                  VentusIconButton(
                    icon: VentusIcons.bell,
                    semanticLabel: 'Notifications',
                    badge: true,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s4),
              VentusAddRow(label: 'Add activity', onTap: () {}),
              const SizedBox(height: AppSpacing.s4),
              VentusSearchButton(label: 'Search city', onTap: () {}),
              const SizedBox(height: AppSpacing.s3),
              VentusSearchField(
                controller: TextEditingController(),
                hintText: 'Search',
              ),
            ],
          ),
        ),
        _Section(
          title: 'Section, card & empty state',
          child: Column(
            children: [
              const VentusSectionLabel('Section label'),
              const VentusSectionHeader(
                title: 'Section header',
                actionLabel: 'See all',
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: AppSpacing.s3),
              VentusCard(
                children: [
                  VentusListRow(
                    title: 'USD — US Dollar',
                    subtitle: 'Home currency',
                    selected: true,
                    onTap: () {},
                  ),
                ],
              ),
              const VentusEmptyState(
                icon: VentusIcons.document,
                title: 'Nothing here yet',
                body: 'Empty states share one layout.',
              ),
            ],
          ),
        ),
        _Section(
          title: 'Icons',
          child: Wrap(
            spacing: AppSpacing.s5,
            runSpacing: AppSpacing.s5,
            children: [
              for (final name in VentusIcons.all)
                VentusIcon(name, size: 24, color: colors.ink2),
            ],
          ),
        ),
        _Section(
          title: 'App bar & bottom nav',
          child: Column(
            children: [
              ClipRRect(
                borderRadius: AppRadius.brLg,
                child: Container(
                  color: colors.bg,
                  child: VentusAppBar(
                    title: 'Trip details',
                    action: VentusIcon(
                      VentusIcons.more,
                      size: 22,
                      color: colors.ink,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
              ClipRRect(
                borderRadius: AppRadius.brLg,
                child: VentusBottomNav(
                  active: VentusTab.home,
                  onSelect: (_) {},
                  onAdd: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────── Shared helpers ───────────────────────────

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: context.typography.eyebrow.copyWith(
            color: context.colors.muted,
          ),
        ),
        const SizedBox(height: AppSpacing.s4),
        child,
        const SizedBox(height: AppSpacing.s10),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.brMd,
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(label, style: context.typography.caption),
        ],
      ),
    );
  }
}

class _RadiusBox extends StatelessWidget {
  const _RadiusBox(this.label, this.radius);

  final String label;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: context.colors.primarySoft,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: context.colors.primary, width: 1.5),
          ),
        ),
        const SizedBox(height: AppSpacing.s2),
        Text('$label · ${radius.toInt()}', style: context.typography.caption),
      ],
    );
  }
}

class _ShadowBox extends StatelessWidget {
  const _ShadowBox(this.label, this.shadow);

  final String label;
  final List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: AppRadius.brLg,
            boxShadow: shadow,
          ),
        ),
        const SizedBox(height: AppSpacing.s3),
        Text(label, style: context.typography.caption),
      ],
    );
  }
}
