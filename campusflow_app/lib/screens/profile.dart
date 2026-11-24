// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profil — CampusFlow')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                title: Text(
                  'Étudiant Master 1',
                  style: theme.textTheme.titleMedium,
                ),
                subtitle: Text(
                  'CampusFlow • Université Aube Nouvelle',
                  style: theme.textTheme.labelMedium,
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Aller vers /login'),
            ),
          ],
        ),
      ),
    );
  }
}
