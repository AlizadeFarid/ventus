/// Build-time switches for features whose UI is finished but whose backing
/// service is not.
///
/// The alternative — commenting out the entry point — is what this file
/// replaces: a commented-out call leaves the screen behind it unreferenced,
/// so the analyzer reports it as dead, nobody notices when a refactor breaks
/// it, and turning the feature on means hunting for the right comment. A flag
/// keeps the whole path compiled and type-checked, and switching it is one
/// line.
abstract final class AppFeatures {
  /// Inviting people to plan a trip together (invite sheet, roles, the
  /// Collaborators screen and every entry point to it).
  ///
  /// Off because the invite never reaches the other person: there is no
  /// acceptance flow, and the trip's data isn't shared with them. Showing an
  /// "Invite" button that silently goes nowhere is worse than not having one.
  /// The screen, repository and local storage stay compiled.
  ///
  /// To enable: ship shared-trip access (invite acceptance + RLS on the trip
  /// tables), then flip this to `true`.
  static const collaborators = bool.fromEnvironment(
    'FEATURE_COLLABORATORS',
    defaultValue: false,
  );

  /// Ventus Pro (paywall screen, Profile upsell banner, `/pro` route).
  ///
  /// Off until there is real billing behind it. The screen is complete and its
  /// CTA is honest about being unavailable, but shipping a subscription pitch
  /// whose "Subscribe" button cannot take money reads as unfinished, so it
  /// stays hidden rather than half-live.
  ///
  /// To enable: wire up in-app purchases, then flip this to `true`.
  static const proPlan = bool.fromEnvironment(
    'FEATURE_PRO',
    defaultValue: false,
  );
}
