class HeroSectionModel {
  final String appRating;
  final String appsPublished;
  final String experience;
  final String projectsWorked;

  HeroSectionModel({
    required this.appRating,
    required this.appsPublished,
    required this.experience,
    required this.projectsWorked,
  });

  factory HeroSectionModel.fromMap(Map<String, dynamic> map) {
    return HeroSectionModel(
      appRating: map['appRating'] ?? '4.8',
      appsPublished: map['appsPublished'] ?? '10+',
      experience: map['experience'] ?? '5+',
      projectsWorked: map['projectsWorked'] ?? '25+',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appRating': appRating,
      'appsPublished': appsPublished,
      'experience': experience,
      'projectsWorked': projectsWorked,
    };
  }

  HeroSectionModel copyWith({
    String? appRating,
    String? appsPublished,
    String? experience,
    String? projectsWorked,
  }) {
    return HeroSectionModel(
      appRating: appRating ?? this.appRating,
      appsPublished: appsPublished ?? this.appsPublished,
      experience: experience ?? this.experience,
      projectsWorked: projectsWorked ?? this.projectsWorked,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeroSectionModel &&
          runtimeType == other.runtimeType &&
          appRating == other.appRating &&
          appsPublished == other.appsPublished &&
          experience == other.experience &&
          projectsWorked == other.projectsWorked;

  @override
  int get hashCode =>
      appRating.hashCode ^
      appsPublished.hashCode ^
      experience.hashCode ^
      projectsWorked.hashCode;
}
