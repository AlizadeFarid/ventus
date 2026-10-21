import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A network image that is cached on disk and retries a few times (short,
/// increasing delay) before giving up.
///
/// Backed by [CachedNetworkImage] so the bytes survive a restart: plain
/// [Image.network] caches only in memory, which meant every cold start
/// re-downloaded every cover, avatar and Discover photo — the opposite of what
/// a local-first app should do.
///
/// [Image.network] on its own also never retries: once its [ImageStream] reports
/// an error, that failure is cached for the life of the widget and nothing
/// re-attempts the fetch. In practice this shows up right after a cold app
/// launch on a physical device — the network/TLS stack isn't always fully
/// warmed up in the first moment, a handful of image requests fail together,
/// and they then stay broken for that screen until something happens to
/// rebuild the widget with a fresh key (e.g. navigating away and back, which
/// is why "it fixes itself" after visiting another screen). This widget
/// retries the same URL in place instead of leaving that to chance.
///
/// [errorBuilder] is shown once all attempts are exhausted; pass one that
/// matches the surrounding fallback (or leave it as an empty box so a parent
/// [Stack] fallback shows through, as [TripPhoto] does).
class RetryNetworkImage extends StatefulWidget {
  const RetryNetworkImage({
    super.key,
    required this.url,
    this.fit,
    this.maxAttempts = 3,
    this.errorBuilder,
  });

  final String url;
  final BoxFit? fit;

  /// Total attempts (including the first) before giving up. Must be >= 1.
  final int maxAttempts;

  /// Shown once [maxAttempts] have all failed. Defaults to an empty box.
  final WidgetBuilder? errorBuilder;

  @override
  State<RetryNetworkImage> createState() => _RetryNetworkImageState();
}

class _RetryNetworkImageState extends State<RetryNetworkImage> {
  int _attempt = 0;
  bool _gaveUp = false;

  void _scheduleRetry() {
    if (_attempt >= widget.maxAttempts - 1) {
      if (mounted) setState(() => _gaveUp = true);
      return;
    }
    final delay = Duration(milliseconds: 400 * (1 << _attempt));
    _attempt++;
    Future.delayed(delay, () {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant RetryNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      // A genuinely different image: start its own attempt count fresh.
      _attempt = 0;
      _gaveUp = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_gaveUp) {
      return widget.errorBuilder?.call(context) ?? const SizedBox.shrink();
    }
    return CachedNetworkImage(
      imageUrl: widget.url,
      // A fresh key per attempt forces a new image stream instead of reusing
      // the one that already failed.
      key: ValueKey('${widget.url}#$_attempt'),
      fit: widget.fit,
      // Once on disk the bytes are decoded locally, so a rebuild is instant
      // and there's nothing to fade in — only the first, network-backed
      // decode gets the fade.
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: Duration.zero,
      placeholder: (_, _) => const SizedBox.shrink(),
      errorWidget: (_, _, _) {
        // errorWidget runs during build, so the retry (which calls setState)
        // is scheduled for after this frame instead.
        WidgetsBinding.instance.addPostFrameCallback((_) => _scheduleRetry());
        return const SizedBox.shrink();
      },
    );
  }
}
