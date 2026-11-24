import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../state/taches_provider.dart';
import 'task_detail_screen.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tachesState = ref.watch(tachesProvider);
    final visibleTasks = ref.watch(filteredTasksProvider);
    final todoCount = ref.watch(todoTasksProvider).length;
    final lateCount = ref.watch(lateTasksProvider).length;
    final doneCount = ref.watch(doneTasksProvider).length;

    final effectiveSelectedId =
        _selectedId ?? (visibleTasks.isNotEmpty ? visibleTasks.first.id : null);

    Widget buildList(bool isWide) {
      return Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                ChoiceChip(
                  label: Text('Toutes (${tachesState.tasks.length})'),
                  selected: tachesState.activeFilter == TaskStatusFilter.all,
                  onSelected: (_) => ref
                      .read(tachesProvider.notifier)
                      .setFilter(TaskStatusFilter.all),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('À faire ($todoCount)'),
                  selected: tachesState.activeFilter == TaskStatusFilter.todo,
                  onSelected: (_) => ref
                      .read(tachesProvider.notifier)
                      .setFilter(TaskStatusFilter.todo),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('En retard ($lateCount)'),
                  selected: tachesState.activeFilter == TaskStatusFilter.late,
                  onSelected: (_) => ref
                      .read(tachesProvider.notifier)
                      .setFilter(TaskStatusFilter.late),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Faites ($doneCount)'),
                  selected: tachesState.activeFilter == TaskStatusFilter.done,
                  onSelected: (_) => ref
                      .read(tachesProvider.notifier)
                      .setFilter(TaskStatusFilter.done),
                ),
              ],
            ),
          ),
          Expanded(
            child: visibleTasks.isEmpty
                ? Center(
                    child: Text(
                      'Aucune tâche pour ce filtre.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    itemCount: visibleTasks.length,
                    itemBuilder: (context, index) {
                      final task = visibleTasks[index];
                      final isSelected =
                          isWide && effectiveSelectedId == task.id;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          selected: isSelected,
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) => ref
                                .read(tachesProvider.notifier)
                                .toggleTaskCompleted(task.id),
                          ),
                          title: Text(
                            task.title,
                            style: theme.textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            '${task.courseTitle} • ${task.isCompleted ? "Fait" : (task.isLate ? "En retard" : "À faire")}',
                            style: theme.textTheme.labelMedium,
                          ),
                          onTap: () {
                            setState(() => _selectedId = task.id);
                            if (!isWide) {
                              context.push('/taches/${task.id}');
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusFlow — Tâches'),
        actions: [
          IconButton(
            tooltip: 'Connexion',
            icon: const Icon(Icons.login),
            onPressed: () => context.push('/login'),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 840;
            if (!isWide) {
              return buildList(false);
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 5, child: buildList(true)),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: theme.colorScheme.outline,
                ),
                Expanded(
                  flex: 6,
                  child: effectiveSelectedId == null
                      ? const Center(child: Text('Sélectionnez une tâche'))
                      : TaskDetailBody(taskId: effectiveSelectedId),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nouvelle tâche',
        onPressed: () => context.push('/taches/nouvelle'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
