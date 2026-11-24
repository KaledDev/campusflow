import '../models/course.dart';
import '../models/task.dart';
import '../models/user.dart';

class MockCampusRepository {
  final Duration delay;

  MockCampusRepository({this.delay = const Duration(milliseconds: 200)});

  Future<User> fetchCurrentUser() async {
    try {
      await Future.delayed(delay);
      final rawJson = <String, dynamic>{
        'id': 'u-1',
        'fullName': 'Moussa Ouédraogo',
        'email': 'moussa.ouedraogo@etu.univ.bf',
        'program': 'Master 1 MSI',
      };
      return User.fromJson(rawJson);
    } catch (error) {
      throw Exception('Impossible de charger l\'utilisateur simulé : $error');
    }
  }

  Future<List<Course>> fetchCourses() async {
    try {
      await Future.delayed(delay);
      final rawList = [
        {
          'id': 'c-1',
          'code': 'MOB-501',
          'title': 'Programmation Mobile',
          'instructor': 'M. Compaoré',
        },
        {
          'id': 'c-2',
          'code': 'IA-502',
          'title': 'Intelligence Artificielle',
          'instructor': 'Équipe IA',
        },
      ];
      return rawList.map(Course.fromJson).toList();
    } catch (error) {
      throw Exception('Impossible de charger les cours simulés : $error');
    }
  }

  Future<List<Task>> fetchTasks({bool simulateFailure = false}) async {
    try {
      await Future.delayed(delay);
      if (simulateFailure) {
        throw StateError('Erreur simulée lors de la récupération des tâches.');
      }

      final rawTasks = [
        {
          'id': 't-1',
          'title': 'TP 3 — Modèles Dart & Tests',
          'courseId': 'c-1',
          'dueDate': '2026-11-22T23:59:00.000Z',
          'isCompleted': false,
          'status': 'todo',
          'notes': 'Créer Task, Course, User et vérifier dart test.',
        },
        {
          'id': 't-2',
          'title': 'Compte-rendu TD Recherche',
          'courseId': 'c-2',
          'dueDate': '2026-11-20T18:00:00.000Z',
          'isCompleted': false,
          'status': 'late',
          'notes': 'À finaliser en priorité.',
        },
      ];

      return rawTasks.map(Task.fromJson).toList();
    } catch (error) {
      throw Exception('Échec de chargement des tâches : $error');
    }
  }
}
