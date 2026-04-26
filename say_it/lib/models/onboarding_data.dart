class OnboardingData {
  final String id;
  final String name;
  final String skills;
  final String experience;
  final String motivation;
  final String comments;
  final DateTime createdAt;
  final String language;

  OnboardingData({
    required this.id,
    required this.name,
    required this.skills,
    required this.experience,
    required this.motivation,
    required this.comments,
    required this.createdAt,
    required this.language,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'skills': skills,
      'experience': experience,
      'motivation': motivation,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
      'language': language,
    };
  }

  factory OnboardingData.fromMap(Map<String, dynamic> map) {
    return OnboardingData(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      skills: map['skills'] ?? '',
      experience: map['experience'] ?? '',
      motivation: map['motivation'] ?? '',
      comments: map['comments'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      language: map['language'] ?? 'en',
    );
  }

  OnboardingData copyWith({
    String? id,
    String? name,
    String? skills,
    String? experience,
    String? motivation,
    String? comments,
    DateTime? createdAt,
    String? language,
  }) {
    return OnboardingData(
      id: id ?? this.id,
      name: name ?? this.name,
      skills: skills ?? this.skills,
      experience: experience ?? this.experience,
      motivation: motivation ?? this.motivation,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      language: language ?? this.language,
    );
  }
}