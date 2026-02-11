import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import 'db/app_database.dart';
import 'providers.dart';
import 'router/app_router.dart';
import 'services/import_dedup_service.dart';
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
    unawaited(database.markMissingFiles());
    unawaited(ref.read(notificationServiceProvider).initialize());

    var docs =
        await (database.select(database.documents)..orderBy([
              (t) => OrderingTerm.desc(t.lastOpenedAt),
              (t) => OrderingTerm.desc(t.createdAt),
            ]))
            .get();
    var initialDocumentId = docs.isEmpty ? null : docs.first.id;

    final pendingPath = await ref
        .read(pdfIntentServiceProvider)
        .consumeInitialPdfPath();
    if (pendingPath != null && pendingPath.trim().isNotEmpty) {
      final source = File(pendingPath);
      if (source.existsSync()) {
        try {
          final storage = ref.read(fileStorageServiceProvider);
          final dedup = const ImportDedupService();
          final managed = await storage.copyToManagedStorage(
            sourcePath: source.path,
            folder: 'pdfs',
          );

          Document? duplicate;
          for (final doc in docs) {
            final same = await dedup.filesAreIdentical(
              managed.path,
              doc.pdfPath,
            );
            if (same) {
              duplicate = doc;
              break;
            }
          }

          if (duplicate != null) {
            await storage.deleteIfManaged(managed.path);
            initialDocumentId = duplicate.id;
          } else {
            final title = p.basenameWithoutExtension(source.path);
            final id = await database.createDocument(
              title: title.isEmpty ? 'Opened PDF' : title,
              pdfPath: managed.path,
            );
            initialDocumentId = id;
          }
        } catch (_) {
          // Keep bootstrap resilient even if intent import fails.
        }
      }
    }

    return _AppBootstrapState(
      onboardingSeen: onboardingSeen,
      initialDocumentId: initialDocumentId,
    );
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
          initialDocumentId: snapshot.data!.initialDocumentId,
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
  const _AppBootstrapState({
    required this.onboardingSeen,
    required this.initialDocumentId,
  });

  final bool onboardingSeen;
  final int? initialDocumentId;
}
