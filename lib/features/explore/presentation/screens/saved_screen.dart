import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/refresh.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../trips/presentation/widgets/trip_photo.dart';
import '../../application/saved_controller.dart';
import '../../application/saved_providers.dart';
import '../../domain/saved_place.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Saved tab — destinations the user hearted in Explore (prototype `Explore.jsx`
/// heart action). A grid of saved places, each opening its detail; the filled
/// heart un-saves.
class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    ref.watch(savedSyncProvider);
    final saved =
        ref.watch(savedPlacesProvider).asData?.value ?? const <SavedPlace>[];

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VentusAppBar(title: l10n.navSaved),
            Expanded(
              child: saved.isEmpty
                  ? _Empty()
                  : RefreshIndicator(
                      onRefresh: () => refreshQuietly(
                        () => ref.refresh(savedSyncProvider.future),
                      ),
                      child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        // The bottom inset is added rather than assumed: this
                        // screen opts out of SafeArea's bottom padding (so the
                        // grid can scroll under the home indicator) but the
                        // last row still has to clear it when resting.
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.screen,
                          12,
                          AppSpacing.screen,
                          20 + MediaQuery.paddingOf(context).bottom,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.82,
                            ),
                        itemCount: saved.length,
                        itemBuilder: (context, i) =>
                            _SavedCard(place: saved[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedCard extends ConsumerWidget {
  const _SavedCard({required this.place});

  final SavedPlace place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return VentusTap(
      onTap: () => context.push(AppRoutes.explorePlace(place.destinationId)),
      child: TripPhoto(
        imageUrl: place.imageUrl,
        borderRadius: AppRadius.brLg,
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xC71F1B18), Color(0x001F1B18)],
                    stops: [0.0, 0.6],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: VentusTap(
                onTap: () => ref
                    .read(savedControllerProvider.notifier)
                    .remove(place.destinationId),
                child: Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.24),
                    shape: BoxShape.circle,
                  ),
                  child: VentusIcon(
                    VentusIcons.heartFill,
                    size: 17,
                    color: colors.primary,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 13,
              right: 13,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppFontSize.body,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    place.country,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.caption,
                      color: Colors.white.withValues(alpha: 0.85),
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

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return VentusEmptyState(
      icon: VentusIcons.heart,
      title: l10n.savedEmptyTitle,
      body: l10n.savedEmptyBody,
    );
  }
}
