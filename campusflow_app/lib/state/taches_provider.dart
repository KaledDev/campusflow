import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TaskStatusFilter { all, todo, late, done }

class CampusTask {
  final String id;
  final String title;
  final String courseId;
  final String courseTitle;
  final DateTime dueDate;
  final bool isCompleted;
  final String notes;

  const CampusTask({
    required this.id,
    required this.title,
    required this.courseId,
    required this.courseTitle,
    required this.dueDate,
    required this.isCompleted,
    this.notes = '',
  });

  bool get isLate => !isCompleted && dueDate.isBefore(DateTime.now());

  CampusTask copyWith({
    String? id,
    String? title,
    String? courseId,
    String? courseTitle,
    DateTime? dueDate,
    bool? isCompleted,
    String? notes,
  }) {
    return CampusTask(
      id: id ?? this.id,
      title: title ?? this.title,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }
}

class TachesState {
  final List<CampusTask> tasks;
  final TaskStatusFilter activeFilter;

  const TachesState({
    required this.tasks,
    this.activeFilter = TaskStatusFilter.all,
  });

  TachesState copyWith({
    List<CampusTask>? tasks,
    TaskStatusFilter? activeFilter,
  }) {
    return TachesState(
      tasks: tasks ?? this.tasks,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}

class TachesNotifier extends Notifier<TachesState> {
  @override
  TachesState build() {
    final now = DateTime.now();
    return TachesState(
      tasks: [
        CampusTask(
          id: '1',
          title: 'TP 6 — Navigation GoRouter & Riverpod',
          courseId: 'mob-501',
          courseTitle: 'Programmation Mobile',
          dueDate: now.add(const Duration(days: 2)),
          isCompleted: false,
          notes: 'Vérifier le ShellRoute, /taches/:id et les filtres dérivés.',
        ),
        CampusTask(
          id: '2',
          title: 'Compte-rendu TD Recherche',
          courseId: 'ia-502',
          courseTitle: 'Intelligence Artificielle',
          dueDate: now.subtract(const Duration(days: 1)),
          isCompleted: false,
          notes: 'Tâche en retard à traiter en priorité.',
        ),
        CampusTask(
          id: '3',
          title: 'Modèles Dart & Tests unitaires',
          courseId: 'mob-501',
          courseTitle: 'Programmation Mobile',
          dueDate: now.subtract(const Duration(days: 3)),
          isCompleted: true,
          notes: 'Validé avec dart test.',
        ),
      ],
    );
  }

  void setFilter(TaskStatusFilter filter) {
    state = state.copyWith(activeFilter: filter);
  }

  void addTask({
    required String title,
    required String courseTitle,
    required DateTime dueDate,
    String notes = '',
  }) {
    final nextId = (state.tasks.length + 1).toString();
    final created = CampusTask(
      id: nextId,
      title: title.trim(),
      courseId: courseTitle.toLowerCase().replaceAll(' ', '-'),
      courseTitle: courseTitle.trim().isEmpty ? 'Cours général' : courseTitle.trim(),
      dueDate: dueDate,
      isCompleted: false,
      notes: notes.trim(),
    );

    // Nouvelle liste immuable : on ne modifie jamais la liste existante sur place
    state = state.copyWith(
      tasks: [created, ...state.tasks],
    );
  }

  void toggleTaskCompleted(String taskId) {
    final updatedList = state.tasks.map((task) {
      if (task.id != taskId) return task;
      return task.copyWith(isCompleted: !task.isCompleted);
    }).toList(growable: false);

    state = state.copyWith(tasks: updatedList);
  }
}

final tachesProvider = NotifierProvider<TachesNotifier, TachesState>(
  TachesNotifier.new,
);

/// Fournisseurs dérivés pour les trois états demandés (à faire, faites, en retard)
final todoTasksProvider = Provider<List<CampusTask>>((ref) {
  final tasks = ref.watch(tachesProvider).tasks;
  return tasks.where((t) => !t.isCompleted && !t.isLate).toList(growable: false);
});

final doneTasksProvider = Provider<List<CampusTask>>((ref) {
  final tasks = ref.watch(tachesProvider).tasks;
  return tasks.where((t) => t.isCompleted).toList(growable: false);
});

final lateTasksProvider = Provider<List<CampusTask>>((ref) {
  final tasks = ref.watch(tachesProvider).tasks;
  return tasks.where((t) => t.isLate).toList(growable: false);
});

final filteredTasksProvider = Provider<List<CampusTask>>((ref) {
  final state = ref.watch(tachesProvider);
  switch (state.activeFilter) {
    case TaskStatusFilter.todo:
      return ref.watch(todoTasksProvider);
    case TaskStatusFilter.done:
      return ref.watch(doneTasksProvider);
    case TaskStatusFilter.late:
      return ref.watch(lateTasksProvider);
    case TaskStatusFilter.all:
      return state.tasks;
  }
});