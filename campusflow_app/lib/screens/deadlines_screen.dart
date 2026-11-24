import 'package:flutter/material.dart';

import 'new_task_screen.dart';
import 'task_detail_screen.dart';

enum TaskFilter { all, todo, late, done }

class CampusTaskItem {
  final String id;
  final String title;
  final String courseLabel;
  final String dueLabel;
  final String notes;
  final bool isDone;
  final bool isLate;

  const CampusTaskItem({
    required this.id,
    required this.title,
    required this.courseLabel,
    required this.dueLabel,
    required this.notes,
    this.isDone = false,
    this.isLate = false,
  });

  CampusTaskItem copyWith({
    String? id,
    String? title,
    String? courseLabel,
    String? dueLabel,
    String? notes,
    bool? isDone,
    bool? isLate,
  }) {
    return CampusTaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      courseLabel: courseLabel ?? this.courseLabel,
      dueLabel: dueLabel ?? this.dueLabel,
      notes: notes ?? this.notes,
      isDone: isDone ?? this.isDone,
      isLate: isLate ?? this.isLate,
    );
  }
}

class DeadlinesScreen extends StatefulWidget {
  const DeadlinesScreen({super.key});

  @override
  State<DeadlinesScreen> createState() => _DeadlinesScreenState();
}

class _DeadlinesScreenState extends State<DeadlinesScreen> {
  int _navIndex = 0;
  TaskFilter _selectedFilter = TaskFilter.all;
  String? _selectedTaskId = 't-1';

  final List<CampusTaskItem> _tasks = [
    const CampusTaskItem(
      id: 't-1',
      title: 'TP 5 — Écran Responsive',
      courseLabel: 'Master 1 MSI • Programmation Mobile',
      dueLabel: 'Dimanche 22 Nov. à 23h59',
      notes:
          'Assembler Scaffold, ListView.builder, Formulaire et LayoutBuilder (840 dp).',
    ),
    const CampusTaskItem(
      id: 't-2',
      title: 'Compte-rendu TD IA',
      courseLabel: 'Master 1 MSI • Intelligence Artificielle',
      dueLabel: 'Vendredi 20 Nov. à 18h00',
      notes: 'Synthèse des algorithmes de recherche et cas pratiques.',
      isLate: true,
    ),
    const CampusTaskItem(
      id: 't-3',
      title: 'Modèles Dart & Tests',
      courseLabel: 'Master 1 MSI • Programmation Mobile',
      dueLabel: 'Mercredi 18 Nov. à 20h00',
      notes: 'Classes immuables Task, Course, User + dart test.',
      isDone: true,
    ),
  ];

  List<CampusTaskItem> get _filteredTasks {
    switch (_selectedFilter) {
      case TaskFilter.todo:
        return _tasks.where((t) => !t.isDone && !t.isLate).toList();
      case TaskFilter.late:
        return _tasks.where((t) => !t.isDone && t.isLate).toList();
      case TaskFilter.done:
        return _tasks.where((t) => t.isDone).toList();
      case TaskFilter.all:
        return _tasks;
    }
  }

  CampusTaskItem? get _selectedTask {
    if (_tasks.isEmpty) return null;
    for (final task in _tasks) {
      if (task.id == _selectedTaskId) return task;
    }
    return _tasks.first;
  }

  void _toggleTaskDone(String taskId) {
    setState(() {
      for (var i = 0; i < _tasks.length; i++) {
        if (_tasks[i].id == taskId) {
          final current = _tasks[i];
          final nextDone = !current.isDone;
          _tasks[i] = current.copyWith(
            isDone: nextDone,
            isLate: nextDone ? false : current.isLate,
          );
          break;
        }
      }
    });
  }

  Future<void> _openNewTaskForm() async {
    final created = await Navigator.of(context).push<CampusTaskItem>(
      MaterialPageRoute(builder: (_) => const NewTaskScreen()),
    );

    if (created != null && mounted) {
      setState(() {
        _tasks.insert(0, created);
        _selectedTaskId = created.id;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tâche ajoutée : ${created.title}')),
      );
    }
  }

  void _onTaskTap(CampusTaskItem task, bool isWideLayout) {
    setState(() {
      _selectedTaskId = task.id;
    });

    if (!isWideLayout) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TaskDetailScreen(
            task: task,
            onToggleDone: () {
              _toggleTaskDone(task.id);
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }
  }

  Widget _buildTaskList(BuildContext context, bool isWideLayout) {
    final theme = Theme.of(context);
    final tasks = _filteredTasks;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('Toutes'),
                selected: _selectedFilter == TaskFilter.all,
                onSelected: (_) =>
                    setState(() => _selectedFilter = TaskFilter.all),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('À faire'),
                selected: _selectedFilter == TaskFilter.todo,
                onSelected: (_) =>
                    setState(() => _selectedFilter = TaskFilter.todo),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('En retard'),
                selected: _selectedFilter == TaskFilter.late,
                onSelected: (_) =>
                    setState(() => _selectedFilter = TaskFilter.late),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Faites'),
                selected: _selectedFilter == TaskFilter.done,
                onSelected: (_) =>
                    setState(() => _selectedFilter = TaskFilter.done),
              ),
            ],
          ),
        ),
        Expanded(
          child: tasks.isEmpty
              ? Center(
                  child: Text(
                    'Aucune tâche dans ce filtre.',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final isSelected =
                        isWideLayout && _selectedTask?.id == task.id;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      color: isSelected
                          ? theme.colorScheme.surfaceContainerHighest
                          : theme.colorScheme.surface,
                      child: ListTile(
                        selected: isSelected,
                        leading: Icon(
                          task.isDone
                              ? Icons.check_circle
                              : task.isLate
                              ? Icons.warning_amber_rounded
                              : Icons.radio_button_unchecked,
                          color: task.isDone
                              ? theme.colorScheme.primary
                              : task.isLate
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        title: Text(
                          task.title,
                          style: theme.textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          '${task.courseLabel} • ${task.dueLabel}',
                          style: theme.textTheme.labelMedium,
                        ),
                        onTap: () => _onTaskTap(task, isWideLayout),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Échéances — CampusFlow')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWideLayout = constraints.maxWidth >= 840;

            if (!isWideLayout) {
              return _buildTaskList(context, false);
            }

            final selected = _selectedTask;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 5, child: _buildTaskList(context, true)),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: theme.colorScheme.outline,
                ),
                Expanded(
                  flex: 6,
                  child: selected == null
                      ? Center(
                          child: Text(
                            'Sélectionnez une tâche.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        )
                      : TaskDetailBody(
                          task: selected,
                          onToggleDone: () => _toggleTaskDone(selected.id),
                        ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openNewTaskForm,
        tooltip: 'Ajouter une tâche',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (index) => setState(() => _navIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Échéances',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Cours',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
