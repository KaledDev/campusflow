// lib/screens/courses_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/taches_provider.dart';

class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tasks = ref.watch(tachesProvider).tasks;
    final courseNames = tasks.map((t) => t.courseTitle).toSet().toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Cours — CampusFlow')),
      body: ListView.builder(
        itemCount: courseNames.length,
        itemBuilder: (context, index) {
          final course = courseNames[index];
          final count = tasks.where((t) => t.courseTitle == course).length;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(course, style: theme.textTheme.titleMedium),
              subtitle: Text('$count tâche(s) associée(s)', style: theme.textTheme.labelMedium),
            ),
          );
        },
      ),
    );
  }
}