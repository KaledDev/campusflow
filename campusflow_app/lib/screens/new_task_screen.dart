import 'package:flutter/material.dart';

import 'deadlines_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _courseController = TextEditingController(
    text: 'Master 1 MSI • Programmation Mobile',
  );
  final _dueController = TextEditingController(
    text: 'Dimanche 22 Nov. à 23h59',
  );
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    _dueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final title = _titleController.text.trim();
    final course = _courseController.text.trim().isEmpty
        ? 'Master 1 MSI • Cours'
        : _courseController.text.trim();
    final due = _dueController.text.trim().isEmpty
        ? 'À planifier'
        : _dueController.text.trim();
    final notes = _notesController.text.trim().isEmpty
        ? 'Aucune note ajoutée.'
        : _notesController.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tâche enregistrée avec succès.')),
    );

    final newTask = CampusTaskItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      courseLabel: course,
      dueLabel: due,
      notes: notes,
    );

    Navigator.of(context).pop(newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle tâche')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre de la tâche *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez saisir un titre de tâche.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _courseController,
                  decoration: const InputDecoration(
                    labelText: 'Cours / Module',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dueController,
                  decoration: const InputDecoration(
                    labelText: 'Échéance',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Notes / Consignes',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _submit,
                  child: const Text('Enregistrer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
