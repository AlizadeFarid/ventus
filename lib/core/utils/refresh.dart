/// Runs a pull-to-refresh action and waits for it, without ever completing
/// with an error.
///
/// A [RefreshIndicator]'s `onRefresh` future must not throw: when it does, the
/// spinner stays on screen and the failure surfaces as an unhandled async
/// error rather than as anything the user can act on. Swallowing it here is
/// safe because the refreshed provider keeps the error itself — the screen
/// watching it still renders its own error state.
///
/// ```dart
/// RefreshIndicator(
///   onRefresh: () => refreshQuietly(() => ref.refresh(fooProvider.future)),
///   ...
/// )
/// ```
Future<void> refreshQuietly(Future<void> Function() run) async {
  try {
    await run();
  } catch (_) {
    // Intentionally ignored — see the doc comment.
  }
}
