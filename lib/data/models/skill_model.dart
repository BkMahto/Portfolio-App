class SkillModel {
  final String name;
  final String tag;
  final String expertise;
  final String category; // 'core' | 'frameworks' | 'tools'
  final String description;
  final String? docUrl;
  final String? searchSuffix;

  SkillModel({
    required this.name,
    required this.tag,
    required this.expertise,
    required this.category,
    required this.description,
    this.docUrl,
    this.searchSuffix,
  });

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      name: map['name'] ?? '',
      tag: map['tag'] ?? '',
      expertise: map['expertise'] ?? '',
      category: map['category'] ?? 'core',
      description: map['description'] ?? '',
      docUrl: map['docUrl'],
      searchSuffix: map['searchSuffix'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'tag': tag,
      'expertise': expertise,
      'category': category,
      'description': description,
      'docUrl': docUrl,
      'searchSuffix': searchSuffix,
    };
  }

  SkillModel copyWith({
    String? name,
    String? tag,
    String? expertise,
    String? category,
    String? description,
    String? docUrl,
    String? searchSuffix,
  }) {
    return SkillModel(
      name: name ?? this.name,
      tag: tag ?? this.tag,
      expertise: expertise ?? this.expertise,
      category: category ?? this.category,
      description: description ?? this.description,
      docUrl: docUrl ?? this.docUrl,
      searchSuffix: searchSuffix ?? this.searchSuffix,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkillModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          tag == other.tag &&
          expertise == other.expertise &&
          category == other.category &&
          description == other.description &&
          docUrl == other.docUrl &&
          searchSuffix == other.searchSuffix;

  @override
  int get hashCode =>
      name.hashCode ^
      tag.hashCode ^
      expertise.hashCode ^
      category.hashCode ^
      description.hashCode ^
      docUrl.hashCode ^
      searchSuffix.hashCode;
}
