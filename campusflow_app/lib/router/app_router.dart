import 'package:campusflow_app/screens/profile.dart';
import 'package:campusflow_app/screens/tasks_screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/courses_screen.dart';
import '../screens/login_screen.dart';
import '../screens/new_task_screen.dart';
import '../screens/task_detail_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/taches',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/taches/nouvelle',
      builder: (context, state) => const NewTaskScreen(),
    ),
    GoRoute(
      path: '/taches/:id',
      builder: (context, state) {
        final taskId = state.pathParameters['id'] ?? '';
        return TaskDetailScreen(taskId: taskId);
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        final location = state.uri.path;
        var currentIndex = 0;
        if (location.startsWith('/cours')) {
          currentIndex = 1;
        } else if (location.startsWith('/profil')) {
          currentIndex = 2;
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              if (index == 0) context.go('/taches');
              if (index == 1) context.go('/cours');
              if (index == 2) context.go('/profil');
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.event_note_outlined),
                selectedIcon: Icon(Icons.event_note),
                label: 'Tâches',
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
      },
      routes: [
        GoRoute(
          path: '/taches',
          builder: (context, state) => const TasksScreen(),
        ),
        GoRoute(
          path: '/cours',
          builder: (context, state) => const CoursesScreen(),
        ),
        GoRoute(
          path: '/profil',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
