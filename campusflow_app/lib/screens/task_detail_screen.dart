import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/taches_provider.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détail (#$taskId)')),
      body: SafeArea(child: TaskDetailBody(taskId: taskId)),
    );
  }
}

class TaskDetailBody extends ConsumerWidget {
  const TaskDetailBody({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tasks = ref.watch(tachesProvider).tasks;

    CampusTask? task;
    for (final item in tasks) {
      if (item.id == taskId) {
        task = item;
        break;
      }
    }

    if (task == null) {
      return Center(
        child: Text(
          'Tâche introuvable ($taskId)',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    final currentTask = task;
    final statusLabel = currentTask.isCompleted
        ? 'Fait'
        : (currentTask.isLate ? 'En retard' : 'À faire');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentTask.courseTitle,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(currentTask.title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Statut actuel : $statusLabel',
                    style: theme.textTheme.titleMedium,
                  ),
                  if (currentTask.notes.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(currentTask.notes, style: theme.textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              ref
                  .read(tachesProvider.notifier)
                  .toggleTaskCompleted(currentTask.id);
            },
            child: Text(
              currentTask.isCompleted
                  ? 'Marquer comme non fait'
                  : 'Marquer comme fait',
            ),
          ),
        ],
      ),
    );
  }
}
