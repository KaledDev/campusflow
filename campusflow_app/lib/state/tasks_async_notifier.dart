// lib/state/tasks_async_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/auth_storage.dart';
import '../data/repositories/task_repository.dart';

final authStorageProvider = Provider<AuthStorage>((ref) => AuthStorage());

// À remplacer par ApiTaskRepository(apiClient) dans main.dart
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  throw UnimplementedError(
    'taskRepositoryProvider doit être fourni dans main.dart',
  );
});

class TasksAsyncNotifier extends AsyncNotifier<List<RemoteTask>> {
  @override
  Future<List<RemoteTask>> build() async {
    return ref.read(taskRepositoryProvider).fetchTasks();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(taskRepositoryProvider).fetchTasks(),
    );
  }

  Future<void> addTask({
    required String title,
    required String courseTitle,
    required DateTime dueDate,
    String notes = '',
  }) async {
    final previous = state.asData?.value ?? const <RemoteTask>[];
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final created = await ref
          .read(taskRepositoryProvider)
          .createTask(
            title: title,
            courseTitle: courseTitle,
            dueDate: dueDate,
            notes: notes,
          );
      return [created, ...previous];
    });
  }

  Future<void> toggleTask(RemoteTask task) async {
    final previous = state.asData?.value ?? const <RemoteTask>[];
    state = await AsyncValue.guard(() async {
      final updated = await ref
          .read(taskRepositoryProvider)
          .toggleCompleted(task);
      return previous
          .map((item) => item.id == updated.id ? updated : item)
          .toList(growable: false);
    });
  }

  Future<void> removeTask(String id) async {
    final previous = state.asData?.value ?? const <RemoteTask>[];
    state = await AsyncValue.guard(() async {
      await ref.read(taskRepositoryProvider).deleteTask(id);
      return previous.where((item) => item.id != id).toList(growable: false);
    });
  }

  final tasksAsyncProvider =
      AsyncNotifierProvider<TasksAsyncNotifier, List<RemoteTask>>(
        TasksAsyncNotifier.new,
      );
}
