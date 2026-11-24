// lib/data/repositories/fake_task_repository.dart
import 'task_repository.dart';

class FakeTaskRepository implements TaskRepository {
  FakeTaskRepository({this.shouldFail = false})
    : _items = [
        RemoteTask(
          id: '1',
          title: 'TP 7 — Tests FakeTaskRepository',
          courseId: 'mob-501',
          courseTitle: 'Programmation Mobile',
          dueDate: DateTime.now().add(const Duration(days: 2)),
          isCompleted: false,
          notes: 'Données locales en mémoire.',
        ),
      ];

  final bool shouldFail;
  final List<RemoteTask> _items;

  @override
  Future<List<RemoteTask>> fetchTasks() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (shouldFail) {
      throw Exception('Erreur réseau simulée');
    }
    return List.unmodifiable(_items);
  }

  @override
  Future<RemoteTask> createTask({
    required String title,
    required String courseTitle,
    required DateTime dueDate,
    String notes = '',
  }) async {
    final created = RemoteTask(
      id: (_items.length + 1).toString(),
      title: title,
      courseId: 'fake-course',
      courseTitle: courseTitle,
      dueDate: dueDate,
      isCompleted: false,
      notes: notes,
    );
    _items.insert(0, created);
    return created;
  }

  @override
  Future<RemoteTask> toggleCompleted(RemoteTask task) async {
    final idx = _items.indexWhere((t) => t.id == task.id);
    if (idx == -1) return task;
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    _items[idx] = updated;
    return updated;
  }

  @override
  Future<void> deleteTask(String id) async {
    _items.removeWhere((t) => t.id == id);
  }

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Email et mot de passe requis');
    }
    return 'fake-secure-token';
  }
}
