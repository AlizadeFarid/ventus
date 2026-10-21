import 'package:flutter/widgets.dart';

/// Corner-radius scale from `tokens.css`. Theme-invariant constants.
///
/// Raw values are exposed for ad-hoc use; [BorderRadius] helpers cover the
/// common case. `full` is an arbitrarily large value to produce pill / circle
/// shapes.
abstract final class AppRadius {
  static const double xs = 8; // tiny tiles, checkboxes
  static const double sm = 12; // small chips, tags
  static const double md = 18; // button / input
  static const double lg = 20; // card
  static const double xl = 32; // sheet
  static const double full = 999; // pill / circle

  static const BorderRadius brXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brFull = BorderRadius.all(Radius.circular(full));
}
