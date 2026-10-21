import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/router/app_router.dart';
import '../../features/trips/application/create_trip_controller.dart';
import 'create_trip_sheet.dart';
import 'offline_banner.dart';
import 'ventus_bottom_nav.dart';

/// Chrome for the four primary destinations: the active branch's content above
/// a single, persistent [VentusBottomNav].
///
/// The bar lives here, once, rather than being rebuilt by each tab screen.
/// Combined with [StatefulShellRoute.indexedStack] in the router, that is what
/// makes a tab switch keep its scroll position and its own back stack — before
/// this, every tab was a top-level `context.go`, so switching tabs tore the
/// previous screen down and rebuilt the next one from scratch.
class VentusShell extends StatelessWidget {
  const VentusShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Sits above every tab rather than inside each screen, so the
            // message appears once and in the same place wherever the user is.
            const OfflineBanner(),
            Expanded(child: navigationShell),
            VentusBottomNav(
              active: VentusTab.values[navigationShell.currentIndex],
              onSelect: (tab) => navigationShell.goBranch(
                tab.index,
                // Tapping the tab you are already on pops that branch back to
                // its root — the standard iOS/Android behaviour.
                initialLocation: tab.index == navigationShell.currentIndex,
              ),
              onAdd: () => openCreateTripFlow(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// Body wrapper for a tab's root screen.
///
/// The bottom bar and [SafeArea] now come from [VentusShell], so this is just
/// the content — kept as a widget so tab screens read the same as before and
/// so there is one place to add per-tab chrome later.
class TabScaffold extends StatelessWidget {
  const TabScaffold({super.key, required this.active, required this.child});

  /// Which tab this screen is. Retained for readability at the call site (the
  /// shell is the one that actually tracks the selection).
  final VentusTab active;

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// Navigates to a primary tab's route from *outside* the shell (a pushed
/// detail screen, an empty-state CTA). Inside the shell, prefer
/// `navigationShell.goBranch` — see [VentusShell].
void goToTab(BuildContext context, VentusTab tab) {
  final route = switch (tab) {
    VentusTab.home => AppRoutes.home,
    VentusTab.trips => AppRoutes.allTrips,
    VentusTab.tools => AppRoutes.tools,
    VentusTab.profile => AppRoutes.profile,
  };
  context.go(route);
}

/// Opens the [+] action's AI-vs-manual choice sheet, then pushes the Create
/// Trip flow with the picked entry. Shared so every [+] button (bottom nav,
/// Home, Profile) behaves the same way.
Future<void> openCreateTripFlow(BuildContext context) async {
  final choice = await showCreateTripSheet(context);
  if (choice == null || !context.mounted) return;
  context.push(
    AppRoutes.createTrip,
    extra: choice == CreateTripChoice.ai
        ? CreateTripEntry.ai
        : CreateTripEntry.manual,
  );
}
