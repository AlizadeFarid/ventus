import 'package:flutter/painting.dart';

/// Colours for content drawn over photos and gradients (hero images, cover
/// cards, glass pills). Photos look the same in light and dark, so these are
/// theme-invariant — unlike the [AppColors] tokens.
///
/// Scrims use the warm ink base (`1F1B18`) rather than a cool blue-black, so
/// the darkening reads as part of the palette instead of a grey wash.
abstract final class AppOverlay {
  /// Primary text / icons on a photo.
  static const Color onPhoto = Color(0xFFFFFFFF);

  /// Secondary text on a photo (dates, place names).
  static const Color onPhotoStrong = Color(0xE6FFFFFF);

  /// Tertiary text on a photo (captions, subtitles).
  static const Color onPhotoMuted = Color(0xCCFFFFFF);

  /// Frosted fill behind pills and icon buttons on a photo.
  static const Color glassFill = Color(0x2EFFFFFF);

  /// Edge of a frosted surface, where one is needed.
  static const Color glassStroke = Color(0x40FFFFFF);
}
