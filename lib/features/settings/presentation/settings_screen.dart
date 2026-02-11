import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../../core/providers.dart';
import '../../../shared/widgets/cyber_background.dart';
import '../../../shared/widgets/cyber_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final prefAsync = ref.watch(notificationPreferenceProvider);
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Settings')),
      body: CyberBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 22),
            children: [
              CyberCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Classic library styling with full light/dark parity.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 14),
                    SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text('System'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text('Light'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text('Dark'),
                        ),
                      ],
                      selected: {themeMode},
                      onSelectionChanged: (selection) {
                        ref
                            .read(themeModeProvider.notifier)
                            .setThemeMode(selection.first);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              prefAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text('Notification error: $error'),
                data: (pref) => CyberCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Reminders',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Time-based reminders with streak and completion aware messaging.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text('Scheduled at ${pref.localTime}'),
                          const Spacer(),
                          if (pref.enabled)
                            Chip(
                              label: const Text('Enabled'),
                              avatar: Icon(
                                Icons.notifications_active_outlined,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            )
                          else
                            const Chip(label: Text('Disabled')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Streak-aware reminders'),
                        subtitle: const Text(
                          'Protect ongoing streaks in message copy',
                        ),
                        value: pref.streakEnabled,
                        onChanged: (value) => _updateNotificationPreference(
                          ref,
                          pref,
                          streakEnabled: value,
                        ),
                      ),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Completion-aware reminders'),
                        subtitle: const Text(
                          'Different messaging when reading has progressed',
                        ),
                        value: pref.completionEnabled,
                        onChanged: (value) => _updateNotificationPreference(
                          ref,
                          pref,
                          completionEnabled: value,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton.icon(
                            onPressed: () => _chooseDailyReminder(
                              context: context,
                              ref: ref,
                              pref: pref,
                              stats: statsAsync.value,
                            ),
                            icon: const Icon(Icons.alarm_rounded),
                            label: const Text('Set / Update Reminder'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () async {
                              await ref
                                  .read(notificationServiceProvider)
                                  .cancelDailyReminder();
                              await _updateNotificationPreference(
                                ref,
                                pref,
                                enabled: false,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Daily reminder disabled.'),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.notifications_off_rounded),
                            label: const Text('Disable Reminder'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _chooseDailyReminder({
    required BuildContext context,
    required WidgetRef ref,
    required NotificationPreference pref,
    required DashboardStats? stats,
  }) async {
    final defaultTime = _parseLocalTime(pref.localTime);
    final picked = await showTimePicker(
      context: context,
      initialTime: defaultTime,
    );
    if (picked == null) {
      return;
    }

    final effectiveStats =
        stats ?? await ref.read(appDatabaseProvider).getDashboardStats();
    final message = _buildReminderMessage(
      stats: effectiveStats,
      streakEnabled: pref.streakEnabled,
      completionEnabled: pref.completionEnabled,
    );

    await ref
        .read(notificationServiceProvider)
        .scheduleDailyReminder(time: picked, message: message);

    final hh = picked.hour.toString().padLeft(2, '0');
    final mm = picked.minute.toString().padLeft(2, '0');
    await _updateNotificationPreference(
      ref,
      pref,
      enabled: true,
      localTime: '$hh:$mm',
    );

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Reminder scheduled at $hh:$mm')));
    }
  }

  Future<void> _updateNotificationPreference(
    WidgetRef ref,
    NotificationPreference current, {
    bool? enabled,
    String? localTime,
    bool? streakEnabled,
    bool? completionEnabled,
  }) async {
    await ref
        .read(appDatabaseProvider)
        .updateNotificationPreference(
          NotificationPreferencesCompanion(
            id: const Value(1),
            enabled: Value(enabled ?? current.enabled),
            localTime: Value(localTime ?? current.localTime),
            streakEnabled: Value(streakEnabled ?? current.streakEnabled),
            completionEnabled: Value(
              completionEnabled ?? current.completionEnabled,
            ),
          ),
        );
    ref.invalidate(notificationPreferenceProvider);
  }

  TimeOfDay _parseLocalTime(String value) {
    final split = value.split(':');
    if (split.length != 2) {
      return const TimeOfDay(hour: 20, minute: 0);
    }
    final hh = int.tryParse(split.first) ?? 20;
    final mm = int.tryParse(split.last) ?? 0;
    return TimeOfDay(hour: hh.clamp(0, 23), minute: mm.clamp(0, 59));
  }

  String _buildReminderMessage({
    required DashboardStats stats,
    required bool streakEnabled,
    required bool completionEnabled,
  }) {
    if (completionEnabled && stats.pagesReadTotal > 0) {
      return 'You already logged ${stats.pagesReadTotal} pages. Add one more reading session today.';
    }
    if (streakEnabled && stats.streakDays > 0) {
      return 'Protect your ${stats.streakDays}-day streak. Open Copia and read now.';
    }
    return 'Daily reading checkpoint: open Copia and complete a focused session.';
  }
}
