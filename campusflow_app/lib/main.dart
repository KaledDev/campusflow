import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

void main() {
  runApp(const CampusFlowApp());
}

class CampusFlowApp extends StatelessWidget {
  const CampusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const _HomeTitleWidget(),
    );
  }
}

class _HomeTitleWidget extends StatelessWidget {
  const _HomeTitleWidget();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('CampusFlow')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/flutter.svg',
              height: 96,
              errorBuilder: (_, __, ___) => Icon(
                Icons.school_outlined,
                size: 72,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text('CampusFlow', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Suivi des cours, échéances et tâches',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: () {}, child: const Text('Commencer')),
          ],
        ),
      ),
    );
  }
}
