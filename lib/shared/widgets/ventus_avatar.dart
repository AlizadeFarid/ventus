import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import 'ventus_tap.dart';

/// Circular user avatar (prototype `Home.jsx` → Avatar).
///
/// Shows the user's photo when there is one — an uploaded avatar or the one
/// Google/Apple supplied at sign-in — and falls back to their initials on the
/// brand gradient. The image is cached on disk like every other remote image in
/// the app, so it doesn't re-download on each launch.
class VentusAvatar extends StatelessWidget {
  const VentusAvatar({
    super.key,
    this.initials = 'V',
    this.imageUrl,
    this.size = 40,
    this.onTap,
  });

  /// Up to two letters, used when there is no [imageUrl].
  final String initials;

  /// Public URL of the user's photo, or null.
  final String? imageUrl;

  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final url = imageUrl;

    final avatar = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: url == null ? colors.gradientHero : null,
        shape: BoxShape.circle,
        image: url == null
            ? null
            : DecorationImage(
                image: CachedNetworkImageProvider(url),
                fit: BoxFit.cover,
              ),
      ),
      child: url != null
          ? null
          : Text(
              initials,
              style: TextStyle(
                color: colors.onPrimary,
                fontWeight: FontWeight.w800,
                fontSize: size * 0.42,
                height: 1,
              ),
            ),
    );

    if (onTap == null) return avatar;
    return VentusTap(onTap: onTap, child: avatar);
  }
}
