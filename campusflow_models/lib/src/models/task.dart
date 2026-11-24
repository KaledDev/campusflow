enum TaskStatus { todo, late, done }

class Task {
  final String id;
  final String title;
  final String courseId;
  final DateTime dueDate;
  final bool isCompleted;
  final TaskStatus status;
  final String? notes;

  const Task({
    required this.id,
    required this.title,
    required this.courseId,
    required this.dueDate,
    required this.isCompleted,
    required this.status,
    this.notes,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final title = json['title']?.toString() ?? '';
    if (id.isEmpty || title.isEmpty) {
      throw const FormatException('Task JSON invalide : id ou title manquant.');
    }

    final rawDueDate =
        json['dueDate']?.toString() ?? json['due_date']?.toString();
    if (rawDueDate == null || rawDueDate.isEmpty) {
      throw const FormatException('Task JSON invalide : dueDate manquante.');
    }
    final parsedDate = DateTime.parse(rawDueDate);

    final completed =
        json['isCompleted'] as bool? ?? json['is_completed'] as bool? ?? false;

    final statusStr = (json['status']?.toString() ?? '').toLowerCase();
    final TaskStatus resolvedStatus;
    if (completed || statusStr == 'done' || statusStr == 'completed') {
      resolvedStatus = TaskStatus.done;
    } else if (statusStr == 'late' || statusStr == 'overdue') {
      resolvedStatus = TaskStatus.late;
    } else {
      resolvedStatus = TaskStatus.todo;
    }

    return Task(
      id: id,
      title: title,
      courseId:
          json['courseId']?.toString() ?? json['course_id']?.toString() ?? '',
      dueDate: parsedDate,
      isCompleted: completed,
      status: resolvedStatus,
      notes: json['notes']?.toString(),
    );
  }

  Task copyWith({
    String? id,
    String? title,
    String? courseId,
    DateTime? dueDate,
    bool? isCompleted,
    TaskStatus? status,
    String? notes,
  }) {
    final nextCompleted = isCompleted ?? this.isCompleted;
    final nextStatus =
        status ?? (nextCompleted ? TaskStatus.done : this.status);

    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      courseId: courseId ?? this.courseId,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: nextCompleted,
      status: nextStatus,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'courseId': courseId,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'status': status.name,
      'notes': notes,
    };
  }
}
