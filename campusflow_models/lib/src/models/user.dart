class User {
  final String id;
  final String fullName;
  final String email;
  final String program;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.program,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final email = json['email']?.toString() ?? '';
    if (id.isEmpty || email.isEmpty) {
      throw const FormatException('User JSON invalide : id ou email manquant.');
    }

    return User(
      id: id,
      fullName: json['fullName']?.toString() ?? json['full_name']?.toString() ?? 'Étudiant',
      email: email,
      program: json['program']?.toString() ?? 'Master 1',
    );
  }

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? program,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      program: program ?? this.program,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'program': program,
    };
  }
}