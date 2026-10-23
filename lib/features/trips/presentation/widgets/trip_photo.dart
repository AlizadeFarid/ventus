import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../shared/widgets/retry_network_image.dart';

/// Curated on-brand gradients used as a cover when there's no photo — picked
/// deterministically from a seed (trip id, destination name, …) so the same
/// item always gets the same look. Mirrors the design's own placeholder cards
/// (the "Tbilisi" / "Roma" style swatches) instead of a generic, unrelated
/// stock illustration, and needs no network call or bundled asset.
const List<LinearGradient> _coverGradients = [
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF46A41), Color(0xFFD8344F)],
  ), // coral
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF5502F), Color(0xFFC23A1E)],
  ), // primary
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF7A45), Color(0xFFE2365B)],
  ), // sunset
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE2573A), Color(0xFFA63A22)],
  ), // terracotta
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD9467A), Color(0xFF9C2A5E)],
  ), // rose
];

/// Picks one of [_coverGradients] deterministically from [seed].
LinearGradient _gradientFor(String seed) =>
    _coverGradients[seed.hashCode.abs() % _coverGradients.length];

/// Rounded cover image with a brand gradient fallback (prototype `Home.jsx` →
/// Photo). The gradient shows while the network image loads, if it fails, or
/// when there's no photo at all, so the layout never collapses or flashes
/// empty — important for the offline, local-first case where a cached image
/// may be unavailable.
class TripPhoto extends StatelessWidget {
  const TripPhoto({
    super.key,
    this.imageUrl,
    this.image,
    this.width,
    this.height,
    this.borderRadius,
    this.child,
    this.seed,
  });

  final String? imageUrl;
  final String? seed;

  /// A local image (e.g. a freshly picked, not-yet-uploaded cover) shown in
  /// preference to [imageUrl]. Useful before an upload completes.
  final ImageProvider? image;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  /// Overlay content (gradients, labels) stacked on top of the image.
  final Widget? child;

  /// Brand gradient shown while a real photo is loading: a monochrome teal
  /// sweep from the theme primary to a deeper shade of it.
  static LinearGradient _loadingGradient(BuildContext context) {
    return context.colors.gradientMain as LinearGradient;
  }

  @override
  Widget build(BuildContext context) {
    final hasUrl = imageUrl != null && imageUrl!.isNotEmpty;
    final hasPhoto = image != null || hasUrl;
    final backgroundGradient = hasPhoto
        ? _loadingGradient(context)
        : (seed != null ? _gradientFor(seed!) : _loadingGradient(context));

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(gradient: backgroundGradient),
            ),
            if (image != null)
              Image(image: image!, fit: BoxFit.cover)
            else if (hasUrl)
              RetryNetworkImage(url: imageUrl!, fit: BoxFit.cover),
            ?child,
          ],
        ),
      ),
    );
  }
}

/// Hero tag for a destination's photo, shared by the cards that show it (Home
/// Discover row, Explore grid) and the Place Detail header, so opening a place
/// grows the photo in place.
String destinationHeroTag(String id) => 'destination-$id';

/// Wraps [child] in a [Hero] that flies only the bare photo, not the card's
/// overlay text and gradient, which would stretch and clip mid-flight.
class DestinationPhotoHero extends StatelessWidget {
  const DestinationPhotoHero({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.child,
  });

  final String id;
  final String? imageUrl;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: destinationHeroTag(id),
      flightShuttleBuilder: (_, _, _, _, _) =>
          TripPhoto(imageUrl: imageUrl, seed: id),
      child: child,
    );
  }
}
