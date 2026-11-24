class Course {
  final String id;
  final String code;
  final String title;
  final String instructor;

  const Course({
    required this.id,
    required this.code,
    required this.title,
    required this.instructor,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final title = json['title']?.toString() ?? '';
    if (id.isEmpty || title.isEmpty) {
      throw const FormatException('Course JSON invalide : id ou title manquant.');
    }

    return Course(
      id: id,
      code: json['code']?.toString() ?? 'COUR',
      title: title,
      instructor: json['instructor']?.toString() ?? 'Enseignant non assigné',
    );
  }

  Course copyWith({
    String? id,
    String? code,
    String? title,
    String? instructor,
  }) {
    return Course(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      instructor: instructor ?? this.instructor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'instructor': instructor,
    };
  }
}