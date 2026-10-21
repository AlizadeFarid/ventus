import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// A placeholder block with a slow shimmer, for content that is still loading.
///
/// Every loading state in the app used to be a bare [CircularProgressIndicator]
/// centred on an empty screen: the layout appeared only once data landed, so
/// the whole page jumped into place at once. A skeleton keeps the shape of what
/// is coming, which makes the wait read as fast and deliberate rather than
/// blank.
///
/// The shimmer is a translucent white/black sweep over [AppColors.surfaceSand],
/// so it works in both themes without a second colour token.
class VentusSkeleton extends StatefulWidget {
  const VentusSkeleton({super.key, this.width, this.height, this.borderRadius});

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  /// A single line of placeholder text, sized like body copy.
  const VentusSkeleton.line({super.key, this.width, this.height = 12})
    : borderRadius = AppRadius.brFull;

  /// A placeholder circle, e.g. for an avatar or icon chip.
  const VentusSkeleton.circle({super.key, required double size})
    : width = size,
      height = size,
      borderRadius = null;

  bool get _isCircle =>
      borderRadius == null && width == height && width != null;

  @override
  State<VentusSkeleton> createState() => _VentusSkeletonState();
}

class _VentusSkeletonState extends State<VentusSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Dark surfaces need a lifting highlight, light ones a settling shadow.
    final highlight = context.isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.55);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // -1 → 2 so the band travels fully off both edges before repeating.
        final t = _controller.value * 3 - 1;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: colors.surfaceSand,
            shape: widget._isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: widget._isCircle
                ? null
                : (widget.borderRadius ?? AppRadius.brMd),
            gradient: LinearGradient(
              begin: Alignment(t - 1, -0.3),
              end: Alignment(t + 1, 0.3),
              colors: [colors.surfaceSand, highlight, colors.surfaceSand],
              stops: const [0.35, 0.5, 0.65],
            ),
          ),
        );
      },
    );
  }
}

/// Loading placeholder shaped like the Home dashboard: greeting, search pill,
/// hero cover, then the module grid. Matching the real layout is the point —
/// the content lands into the shape the user is already looking at.
class VentusHomeSkeleton extends StatelessWidget {
  const VentusHomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        10,
        AppSpacing.screen,
        20,
      ),
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VentusSkeleton.line(width: 90, height: 11),
                  SizedBox(height: 8),
                  VentusSkeleton.line(width: 150, height: 20),
                ],
              ),
            ),
            const VentusSkeleton.circle(size: 42),
            const SizedBox(width: 10),
            const VentusSkeleton.circle(size: 40),
          ],
        ),
        const SizedBox(height: 18),
        const VentusSkeleton(height: 48, borderRadius: AppRadius.brFull),
        const SizedBox(height: 16),
        const VentusSkeleton(height: 180, borderRadius: AppRadius.brLg),
        const SizedBox(height: 14),
        Row(
          children: const [
            Expanded(child: VentusSkeleton(height: 62)),
            SizedBox(width: 10),
            Expanded(child: VentusSkeleton(height: 62)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Expanded(child: VentusSkeleton(height: 62)),
            SizedBox(width: 10),
            Expanded(child: VentusSkeleton(height: 62)),
          ],
        ),
      ],
    );
  }
}

/// Vertically stacked [VentusSkeleton]s shaped like a list of cards — the
/// default loading state for the app's list screens.
class VentusListSkeleton extends StatelessWidget {
  const VentusListSkeleton({
    super.key,
    this.itemCount = 4,
    this.itemHeight = 76,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.screen,
      12,
      AppSpacing.screen,
      20,
    ),
    this.spacing = 12,
  });

  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry padding;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // Not interactive — it must not absorb a pull-to-refresh either.
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (_, _) => SizedBox(height: spacing),
      itemBuilder: (context, _) =>
          VentusSkeleton(height: itemHeight, borderRadius: AppRadius.brLg),
    );
  }
}
