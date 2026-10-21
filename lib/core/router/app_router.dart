import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/env.dart';
import '../config/feature_flags.dart';
import 'go_router_refresh_stream.dart';
import '../../features/auth/application/pin_gate.dart';
import '../../features/auth/presentation/screens/create_account_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/legal_screen.dart';
import '../../features/auth/presentation/screens/pin_setup_screen.dart';
import '../../features/auth/presentation/screens/pin_unlock_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/dev/design_gallery_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/currency_units_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/notifications_screen.dart';
import '../../features/notifications/presentation/screens/notifications_feed_screen.dart';
import '../../features/profile/presentation/screens/about_screen.dart';
import '../../features/profile/presentation/screens/help_screen.dart';
import '../../features/profile/presentation/screens/privacy_security_screen.dart';
import '../../features/profile/presentation/screens/change_password_screen.dart';
import '../../features/profile/presentation/screens/change_pin_screen.dart';
import '../../features/profile/presentation/screens/pro_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/trips/application/create_trip_controller.dart';
import '../../features/trips/presentation/screens/create/create_trip_flow.dart';
import '../../features/trips/presentation/screens/all_trips_screen.dart';
import '../../features/trips/presentation/screens/document_detail_screen.dart';
import '../../features/trips/presentation/screens/home_screen.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/explore/presentation/screens/place_detail_screen.dart';
import '../../features/explore/presentation/screens/saved_screen.dart';
import '../../features/tools/presentation/screens/clock_tool_screen.dart';
import '../../features/tools/presentation/screens/currency_tool_screen.dart';
import '../../features/tools/presentation/screens/tip_tool_screen.dart';
import '../../features/tools/presentation/screens/tools_home_screen.dart';
import '../../features/tools/presentation/screens/weather_tool_screen.dart';
import '../../features/trips/presentation/screens/collaborators_screen.dart';
import '../../features/trips/presentation/screens/trip_detail_screen.dart';
import '../../shared/widgets/tab_scaffold.dart';

/// Application route names/paths, kept in one place to avoid string typos.
abstract final class AppRoutes {
  static const welcome = '/welcome';
  static const signIn = '/sign-in';
  static const createAccount = '/create-account';
  static const forgotPassword = '/forgot-password';

  /// Post-signup "check your inbox" screen (public; the user has no session yet
  /// when email confirmation is required). Carries the email as a query param.
  static const verifyEmailPath = '/verify-email';
  static String verifyEmail(String email) =>
      '$verifyEmailPath?email=${Uri.encodeComponent(email)}';

  /// Enter the emailed reset code + set a new password (public). Email as param.
  static const resetPasswordPath = '/reset-password';
  static String resetPassword(String email) =>
      '$resetPasswordPath?email=${Uri.encodeComponent(email)}';

  /// Legal documents, linked from the sign-up consent (public).
  static const terms = '/legal/terms';
  static const privacy = '/legal/privacy';
  static const pinSetup = '/pin-setup';
  static const pinUnlock = '/pin-unlock';
  static const home = '/home';

  /// Full list of the user's trips, grouped into upcoming + past.
  static const allTrips = '/trips';
  static const createTrip = '/trips/create';

  /// Path template for the Trip Hub; use [tripDetail] to build a concrete path.
  /// The hub's modules (itinerary/checklist/budget/documents/map) are tabs
  /// within this one screen, not separate routes — push with `extra: HubTab.x`
  /// to land directly on a given tab (see [HomeScreen]'s module shortcuts).
  static const tripDetailPath = '/trips/:id';
  static String tripDetail(String id) => '/trips/$id';

  /// Path template for a single document's detail / preview screen.
  static const documentDetailPath = '/trips/:id/documents/:docId';
  static String documentDetail(String id, String docId) =>
      '/trips/$id/documents/$docId';

  static const collaboratorsPath = '/trips/:id/collaborators';
  static String collaborators(String id) => '/trips/$id/collaborators';

  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const currencyUnits = '/profile/units';
  static const notifications = '/profile/notifications';
  static const notificationSettings = '/profile/notifications/settings';
  static const privacySecurity = '/profile/privacy';
  static const about = '/profile/about';
  static const help = '/profile/help';
  static const changePassword = '/profile/privacy/password';
  static const changePin = '/profile/privacy/pin';
  static const pro = '/pro';
  static const settings = '/settings';
  static const gallery = '/dev/gallery';

  // Bottom-nav tabs + their tools/screens.
  static const saved = '/saved';
  static const tools = '/tools';
  static const toolsCurrency = '/tools/currency';
  static const toolsWeather = '/tools/weather';
  static const toolsClock = '/tools/clock';
  static const toolsTip = '/tools/tip';

  /// Explore / Discover full screen + a single place's detail.
  static const explore = '/explore';
  static const explorePlacePath = '/explore/:id';
  static String explorePlace(String id) => '/explore/$id';
}

/// Routes that require an active session.
const _protectedRoutes = {
  AppRoutes.pinSetup,
  AppRoutes.pinUnlock,
  AppRoutes.home,
  AppRoutes.allTrips,
  AppRoutes.createTrip,
  AppRoutes.profile,
  AppRoutes.editProfile,
  AppRoutes.currencyUnits,
  AppRoutes.notifications,
  AppRoutes.notificationSettings,
  AppRoutes.privacySecurity,
  AppRoutes.about,
  AppRoutes.help,
  AppRoutes.changePassword,
  AppRoutes.changePin,
  AppRoutes.pro,
  AppRoutes.settings,
  AppRoutes.saved,
  AppRoutes.tools,
  AppRoutes.explore,
  AppRoutes.gallery,
};

/// Provides the app's [GoRouter].
///
/// When Supabase is configured, an auth guard keeps signed-out users on the
/// auth screens and bounces signed-in users away from them. A signed-in user
/// who set a quick-unlock PIN is also held on [AppRoutes.pinUnlock] until they
/// unlock, once per cold start (see [PinGate]). Without Supabase (fakes / tests)
/// there is no guard.
final appRouterProvider = Provider<GoRouter>((ref) {
  final guarded = Env.isConfigured;
  final auth = guarded ? Supabase.instance.client.auth : null;
  final pinGate = ref.read(pinGateProvider);

  return GoRouter(
    initialLocation: AppRoutes.welcome,
    refreshListenable: auth == null
        ? null
        : Listenable.merge([
            GoRouterRefreshStream(auth.onAuthStateChange),
            pinGate,
          ]),
    redirect: !guarded
        ? null
        : (context, state) {
            final loggedIn = auth!.currentSession != null;
            final loc = state.matchedLocation;
            // Any trip route (create + dynamic `/trips/:id`) requires a session.
            final isProtected =
                _protectedRoutes.contains(loc) ||
                loc.startsWith('/trips/') ||
                loc.startsWith('/tools/') ||
                loc.startsWith('/explore/');
            if (!loggedIn && isProtected) {
              return AppRoutes.welcome;
            }
            // Cold-start PIN gate: a signed-in user with a PIN unlocks first.
            // (Also holds while `hasPin` is still resolving, so content never
            // flashes before a lock.) New users — no PIN yet — pass straight to
            // PIN setup via the auth flow.
            if (loggedIn && pinGate.mustUnlock) {
              return loc == AppRoutes.pinUnlock ? null : AppRoutes.pinUnlock;
            }
            // Once unlocked / no PIN, never strand the user on the unlock screen.
            if (loggedIn && loc == AppRoutes.pinUnlock) {
              return AppRoutes.home;
            }
            // Skip the entry screen for an already-signed-in user on cold start.
            // Sign-in/create are intentionally NOT bounced, so the post-auth
            // navigation to PIN setup isn't pre-empted by this redirect.
            if (loggedIn && loc == AppRoutes.welcome) {
              return AppRoutes.home;
            }
            return null;
          },
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.createAccount,
        builder: (context, state) => const CreateAccountScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyEmailPath,
        builder: (context, state) =>
            VerifyEmailScreen(email: state.uri.queryParameters['email'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.resetPasswordPath,
        builder: (context, state) => ResetPasswordScreen(
          email: state.uri.queryParameters['email'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.terms,
        builder: (context, state) => const LegalScreen(doc: LegalDoc.terms),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        builder: (context, state) => const LegalScreen(doc: LegalDoc.privacy),
      ),
      GoRoute(
        path: AppRoutes.pinSetup,
        builder: (context, state) => const PinSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.pinUnlock,
        builder: (context, state) => const PinUnlockScreen(),
      ),
      // The four bottom-nav destinations. An indexed-stack shell gives each
      // one its own Navigator, so a tab keeps its scroll position and its own
      // back stack across switches (they used to be plain top-level routes,
      // rebuilt from scratch on every tap). Branch order must match
      // [VentusTab] — [VentusShell] maps between them by index.
      StatefulShellRoute(
        builder: (context, state, navigationShell) =>
            VentusShell(navigationShell: navigationShell),
        // The indexed stack is built here rather than via
        // `StatefulShellRoute.indexedStack` so each inactive branch can be
        // wrapped in [HeroMode]. Every branch stays mounted, so without this a
        // trip cover shown on both Home and My Trips would put two Heroes with
        // the same tag in one subtree, and pushing the Trip Hub would throw
        // "multiple heroes share the same tag" (covered by
        // test/hero_shell_probe_test.dart).
        navigatorContainerBuilder: (context, navigationShell, children) =>
            IndexedStack(
              index: navigationShell.currentIndex,
              children: [
                for (var i = 0; i < children.length; i++)
                  HeroMode(
                    enabled: i == navigationShell.currentIndex,
                    child: children[i],
                  ),
              ],
            ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.allTrips,
                builder: (context, state) => const AllTripsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tools,
                builder: (context, state) => const ToolsHomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.createTrip,
        builder: (context, state) {
          final entry = state.extra is CreateTripEntry
              ? state.extra as CreateTripEntry
              : CreateTripEntry.manual;
          return CreateTripFlow(entry: entry);
        },
      ),
      GoRoute(
        path: AppRoutes.tripDetailPath,
        builder: (context, state) => TripDetailScreen(
          tripId: state.pathParameters['id']!,
          initialTab: state.extra is HubTab
              ? state.extra as HubTab
              : HubTab.overview,
        ),
      ),
      GoRoute(
        path: AppRoutes.documentDetailPath,
        builder: (context, state) => DocumentDetailScreen(
          tripId: state.pathParameters['id']!,
          docId: state.pathParameters['docId']!,
        ),
      ),
      if (AppFeatures.collaborators)
        GoRoute(
          path: AppRoutes.collaboratorsPath,
          builder: (context, state) =>
              CollaboratorsScreen(tripId: state.pathParameters['id']!),
        ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.currencyUnits,
        builder: (context, state) => const CurrencyUnitsScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsFeedScreen(),
      ),
      GoRoute(
        path: AppRoutes.notificationSettings,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: AppRoutes.help,
        builder: (context, state) => const HelpScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacySecurity,
        builder: (context, state) => const PrivacySecurityScreen(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.changePin,
        builder: (context, state) => const ChangePinScreen(),
      ),
      // Paywall. Excluded from the route table while `AppFeatures.proPlan` is
      // off, so a deep link can't surface a subscription pitch the app can't
      // yet honour. The screen itself stays compiled — see [AppFeatures].
      if (AppFeatures.proPlan)
        GoRoute(
          path: AppRoutes.pro,
          builder: (context, state) => const ProScreen(),
        ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.toolsCurrency,
        builder: (context, state) => const CurrencyToolScreen(),
      ),
      GoRoute(
        path: AppRoutes.toolsWeather,
        builder: (context, state) => const WeatherToolScreen(),
      ),
      GoRoute(
        path: AppRoutes.toolsClock,
        builder: (context, state) => const ClockToolScreen(),
      ),
      GoRoute(
        path: AppRoutes.toolsTip,
        builder: (context, state) => const TipToolScreen(),
      ),
      GoRoute(
        path: AppRoutes.saved,
        builder: (context, state) => const SavedScreen(),
      ),
      GoRoute(
        path: AppRoutes.explore,
        builder: (context, state) => const ExploreScreen(),
      ),
      GoRoute(
        path: AppRoutes.explorePlacePath,
        builder: (context, state) =>
            PlaceDetailScreen(id: state.pathParameters['id']!),
      ),
      // Dev-only design system showcase. Excluded from the route table
      // entirely outside debug builds so it can't be reached (deep link,
      // direct URL entry, etc.) in release/profile builds, and isn't
      // reachable pre-auth even in debug (see _protectedRoutes below).
      if (kDebugMode)
        GoRoute(
          path: AppRoutes.gallery,
          builder: (context, state) => const DesignGalleryScreen(),
        ),
    ],
  );
});
