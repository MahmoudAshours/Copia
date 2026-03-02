import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/library/presentation/library_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/quote/presentation/quote_maker_screen.dart';
import '../../features/reader/presentation/reader_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/stats/presentation/stats_screen.dart';

String resolveHomeLocation({
  required bool onboardingSeen,
  required int? initialDocumentId,
}) {
  if (!onboardingSeen) {
    return '/onboarding';
  }
  if (initialDocumentId != null) {
    return '/reader/$initialDocumentId';
  }
  return '/library';
}

String resolveInitialLocation({
  required bool onboardingSeen,
  required int? initialDocumentId,
}) {
  return resolveHomeLocation(
    onboardingSeen: onboardingSeen,
    initialDocumentId: initialDocumentId,
  );
}

int? resolveReaderDocumentId(String? rawId) {
  if (rawId == null) {
    return null;
  }
  return int.tryParse(rawId);
}

String? resolveGuardRedirect({
  required String location,
  required bool onboardingSeen,
  required String homeLocation,
}) {
  if (location == '/') {
    return homeLocation;
  }
  if (!onboardingSeen && location != '/onboarding') {
    return '/onboarding';
  }
  if (onboardingSeen && location == '/onboarding') {
    return homeLocation;
  }
  return null;
}

GoRouter createRouter({
  required bool onboardingSeen,
  required int? initialDocumentId,
}) {
  return GoRouter(
    initialLocation: resolveInitialLocation(
      onboardingSeen: onboardingSeen,
      initialDocumentId: initialDocumentId,
    ),
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final currentOnboardingSeen =
          prefs.getBool('onboarding_seen') ?? onboardingSeen;
      final currentHomeLocation = resolveHomeLocation(
        onboardingSeen: currentOnboardingSeen,
        initialDocumentId: initialDocumentId,
      );
      return resolveGuardRedirect(
        location: state.matchedLocation,
        onboardingSeen: currentOnboardingSeen,
        homeLocation: currentHomeLocation,
      );
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SizedBox.shrink()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/library',
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: '/reader/:id',
        redirect: (context, state) {
          final id = resolveReaderDocumentId(state.pathParameters['id']);
          if (id == null) {
            return '/library';
          }
          return null;
        },
        builder: (context, state) {
          final id = resolveReaderDocumentId(state.pathParameters['id']);
          if (id == null) {
            return const LibraryScreen();
          }
          return ReaderScreen(documentId: id);
        },
      ),
      GoRoute(path: '/stats', builder: (context, state) => const StatsScreen()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/quotes',
        builder: (context, state) => const QuoteMakerScreen(),
      ),
    ],
  );
}
