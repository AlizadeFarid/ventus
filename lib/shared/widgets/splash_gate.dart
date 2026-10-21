import 'package:flutter/material.dart';

import 'ventus_logo.dart';

/// Wraps the app and plays a one-time launch animation over it: a full-screen
/// primary backdrop with the white compass mark that gently shrinks and fades,
/// revealing the app beneath. Picks up seamlessly from the native splash (same
/// `#F5502F` background + centred white mark), so there's no flash between them.
class SplashGate extends StatefulWidget {
  const SplashGate({super.key, required this.child});

  final Widget child;

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate>
    with SingleTickerProviderStateMixin {
  // Must match the native splash colour (pubspec.yaml's flutter_native_splash
  // config) for a seamless hand-off — kept as a literal, not context.colors,
  // since it has to be identical to the pre-Flutter native splash regardless
  // of theme.
  static const _brand = Color(0xFFF5502F);

  late final AnimationController _controller;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1900),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            setState(() => _done = true);
          }
        });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!_done)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final t = _controller.value;
                  // Timeline (background stays fully opaque until the very end,
                  // so the app is never seen until the logo has finished). The
                  // mark starts at exactly the native splash size, so there is
                  // no jump on hand-off — it only ever shrinks, slowly:
                  //   0.00–0.12  hold at native size (seamless hand-off)
                  //   0.12–0.74  slow shrink
                  //   0.74–1.00  whole splash fades out → reveals onboarding
                  final shrink = Curves.easeInOut.transform(
                    ((t - 0.12) / 0.62).clamp(0, 1).toDouble(),
                  );
                  final fade = Curves.easeIn.transform(
                    ((t - 0.74) / 0.26).clamp(0, 1).toDouble(),
                  );
                  // 1.0 == the native splash size; shrink down to 0.60 of it.
                  final scale = 1.0 - 0.40 * shrink;

                  return Opacity(
                    opacity: 1 - fade,
                    child: Container(
                      color: _brand,
                      alignment: Alignment.center,
                      child: Transform.scale(
                        scale: scale,
                        // Box size matches the iOS native splash image (256pt),
                        // and the glyph proportions match the PNG exactly, so
                        // the first Flutter frame lands on top of the native
                        // splash with no visible size change.
                        child: const VentusMark(
                          tile: false,
                          color: Colors.white,
                          glyph: _brand,
                          size: 256,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
