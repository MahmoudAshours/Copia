import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class CopiaApp extends ConsumerStatefulWidget {
  const CopiaApp({super.key});

  @override
  ConsumerState<CopiaApp> createState() => _CopiaAppState();
}

class _CopiaAppState extends ConsumerState<CopiaApp> {
  late final Future<_AppBootstrapState> _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _bootstrapFuture = _loadBootstrapState();
  }

  Future<_AppBootstrapState> _loadBootstrapState() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

    final database = ref.read(appDatabaseProvider);
    await database.initDefaults();
    await database.markMissingFiles();
    await ref.read(notificationServiceProvider).initialize();

    return _AppBootstrapState(onboardingSeen: onboardingSeen);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    return FutureBuilder<_AppBootstrapState>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final router = createRouter(
          onboardingSeen: snapshot.data!.onboardingSeen,
        );
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Copia',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          routerConfig: router,
        );
      },
    );
  }
}

class _AppBootstrapState {
  const _AppBootstrapState({required this.onboardingSeen});

  final bool onboardingSeen;
}
