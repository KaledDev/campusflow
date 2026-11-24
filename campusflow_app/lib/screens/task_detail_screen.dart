import 'package:flutter/material.dart';

import 'deadlines_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onToggleDone,
  });

  final CampusTaskItem task;
  final VoidCallback onToggleDone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail de la tâche')),
      body: SafeArea(
        child: TaskDetailBody(task: task, onToggleDone: onToggleDone),
      ),
    );
  }
}

class TaskDetailBody extends StatelessWidget {
  const TaskDetailBody({
    super.key,
    required this.task,
    required this.onToggleDone,
  });

  final CampusTaskItem task;
  final VoidCallback onToggleDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusText = task.isDone
        ? 'Fait'
        : task.isLate
        ? 'En retard'
        : 'À faire';

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
                  Text(task.courseLabel, style: theme.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  Text(task.title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Échéance : ${task.dueLabel}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'État : $statusText',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: task.isDone
                          ? theme.colorScheme.primary
                          : task.isLate
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text('Notes', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(task.notes, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: onToggleDone,
            child: Text(
              task.isDone ? 'Marquer comme non fait' : 'Marquer comme fait',
            ),
          ),
        ],
      ),
    );
  }
}
