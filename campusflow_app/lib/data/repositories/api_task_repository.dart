// lib/data/repositories/api_task_repository.dart
import 'package:dio/dio.dart';

import '../../core/api_client.dart';
import 'task_repository.dart';

class ApiTaskRepository implements TaskRepository {
  ApiTaskRepository(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<RemoteTask>> fetchTasks() async {
    final response = await _apiClient.dio.get('/tasks');
    final data = response.data as List<dynamic>;
    return data
        .map(
          (item) => RemoteTask.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList(growable: false);
  }

  @override
  Future<RemoteTask> createTask({
    required String title,
    required String courseTitle,
    required DateTime dueDate,
    String notes = '',
  }) async {
    final response = await _apiClient.dio.post(
      '/tasks',
      data: {
        'title': title.trim(),
        'courseId': courseTitle.toLowerCase().replaceAll(' ', '-'),
        'courseTitle': courseTitle.trim().isEmpty
            ? 'Cours'
            : courseTitle.trim(),
        'dueDate': dueDate.toIso8601String(),
        'isCompleted': false,
        'notes': notes.trim(),
      },
    );
    return RemoteTask.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  @override
  Future<RemoteTask> toggleCompleted(RemoteTask task) async {
    final nextValue = !task.isCompleted;
    final response = await _apiClient.dio.patch(
      '/tasks/${task.id}',
      data: {'isCompleted': nextValue},
    );
    return RemoteTask.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  @override
  Future<void> deleteTask(String id) async {
    await _apiClient.dio.delete('/tasks/$id');
  }

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      final map = Map<String, dynamic>.from(response.data as Map);
      return (map['token'] ?? map['accessToken'] ?? '').toString();
    } on DioException {
      // Fallback si json-server sert uniquement /users sans route /login personnalisée
      final res = await _apiClient.dio.get(
        '/users',
        queryParameters: {'email': email, 'password': password},
      );
      final users = res.data as List<dynamic>;
      if (users.isEmpty) {
        throw Exception('Identifiants invalides');
      }
      final user = Map<String, dynamic>.from(users.first as Map);
      return (user['token'] ?? 'demo-jwt-token').toString();
    }
  }
}
