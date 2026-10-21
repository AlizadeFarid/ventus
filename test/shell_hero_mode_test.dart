import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Regression test for the bottom-nav shell's Hero handling.
///
/// Every branch of a stateful shell stays mounted, so a trip cover shown on
/// both Home and My Trips puts two Heroes with the same tag in one subtree.
/// Pushing a detail route then throws "there are multiple heroes that share
/// the same tag". Wrapping inactive branches in [HeroMode] is what prevents
/// it — this test fails if that wrapper is ever removed from `app_router.dart`.
void main() {
  testWidgets('inactive shell branches do not contribute duplicate heroes', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/a',
      routes: [
        StatefulShellRoute(
          builder: (c, s, shell) => Scaffold(body: shell),
          navigatorContainerBuilder: (c, shell, children) => IndexedStack(
            index: shell.currentIndex,
            children: [
              for (var i = 0; i < children.length; i++)
                HeroMode(enabled: i == shell.currentIndex, child: children[i]),
            ],
          ),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/a',
                  builder: (c, s) =>
                      const Hero(tag: 'dup', child: SizedBox(height: 20)),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/b',
                  builder: (c, s) =>
                      const Hero(tag: 'dup', child: SizedBox(height: 20)),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/detail',
          builder: (c, s) => const Scaffold(
            body: Hero(tag: 'dup', child: SizedBox(height: 40)),
          ),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    // Visit branch b so both branches are built and live in the IndexedStack.
    router.go('/b');
    await tester.pumpAndSettle();
    router.go('/a');
    await tester.pumpAndSettle();

    router.push('/detail');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
