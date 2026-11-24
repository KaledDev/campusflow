// lib/data/repositories/task_repository.dart
class RemoteTask {
  final String id;
  final String title;
  final String courseId;
  final String courseTitle;
  final DateTime dueDate;
  final bool isCompleted;
  final String notes;

  const RemoteTask({
    required this.id,
    required this.title,
    required this.courseId,
    required this.courseTitle,
    required this.dueDate,
    required this.isCompleted,
    this.notes = '',
  });

  bool get isLate => !isCompleted && dueDate.isBefore(DateTime.now());

  factory RemoteTask.fromJson(Map<String, dynamic> json) {
    return RemoteTask(
      id: json['id'].toString(),
      title: (json['title'] ?? '').toString(),
      courseId: (json['courseId'] ?? 'mob-501').toString(),
      courseTitle: (json['courseTitle'] ?? 'Programmation Mobile').toString(),
      dueDate:
          DateTime.tryParse((json['dueDate'] ?? '').toString()) ??
          DateTime.now().add(const Duration(days: 2)),
      isCompleted: json['isCompleted'] == true,
      notes: (json['notes'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'courseId': courseId,
    'courseTitle': courseTitle,
    'dueDate': dueDate.toIso8601String(),
    'isCompleted': isCompleted,
    'notes': notes,
  };

  RemoteTask copyWith({
    String? id,
    String? title,
    String? courseId,
    String? courseTitle,
    DateTime? dueDate,
    bool? isCompleted,
    String? notes,
  }) {
    return RemoteTask(
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

abstract class TaskRepository {
  Future<List<RemoteTask>> fetchTasks();
  Future<RemoteTask> createTask({
    required String title,
    required String courseTitle,
    required DateTime dueDate,
    String notes,
  });
  Future<RemoteTask> toggleCompleted(RemoteTask task);
  Future<void> deleteTask(String id);
  Future<String> login({required String email, required String password});
}
