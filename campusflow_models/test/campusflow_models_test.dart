import 'package:campusflow_models/campusflow_models.dart';
import 'package:test/test.dart';

void main() {
  group('CampusFlow Models — Séance 3', () {
    test('1. copyWith crée une copie modifiée sans muter l\'original', () {
      final original = Task(
        id: 't-1',
        title: 'TP 3 — Modèles Dart',
        courseId: 'c-1',
        dueDate: DateTime.utc(2026, 11, 22, 23, 59),
        isCompleted: false,
        status: TaskStatus.todo,
      );

      final updated = original.copyWith(
        isCompleted: true,
        status: TaskStatus.done,
      );

      expect(original.isCompleted, isFalse);
      expect(original.status, TaskStatus.todo);
      expect(updated.isCompleted, isTrue);
      expect(updated.status, TaskStatus.done);
      expect(updated.id, original.id);
      expect(updated.title, original.title);
    });

    test('2. fromJson reconstruit correctement Task, Course et User', () {
      final course = Course.fromJson({
        'id': 'c-1',
        'code': 'MOB-501',
        'title': 'Programmation Mobile',
        'instructor': 'M. Compaoré',
      });

      final user = User.fromJson({
        'id': 'u-1',
        'fullName': 'Moussa Ouédraogo',
        'email': 'moussa@exemple.bf',
        'program': 'Master 1 MSI',
      });

      final task = Task.fromJson({
        'id': 't-10',
        'title': 'TP 5 — Responsive',
        'courseId': 'c-1',
        'dueDate': '2026-11-22T23:59:00.000Z',
        'isCompleted': false,
        'status': 'todo',
      });

      expect(course.code, 'MOB-501');
      expect(user.program, 'Master 1 MSI');
      expect(task.title, 'TP 5 — Responsive');
      expect(task.courseId, course.id);
      expect(task.isCompleted, isFalse);
    });

    test(
      '3. lève une erreur attendue sur un JSON invalide ou un échec simulé',
      () async {
        expect(
          () => Task.fromJson({
            'id': '',
            'title': '',
            'dueDate': 'date-invalide',
          }),
          throwsA(isA<FormatException>()),
        );

        final repo = MockCampusRepository(
          delay: const Duration(milliseconds: 10),
        );
        expect(
          () => repo.fetchTasks(simulateFailure: true),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
