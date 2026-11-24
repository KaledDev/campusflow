// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion — CampusFlow')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Accès étudiant', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/taches'),
              child: const Text('Continuer vers /taches'),
            ),
          ],
        ),
      ),
    );
  }
}
