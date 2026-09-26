class CommentModel {
  final int? id;
  final int heroId;
  final String name;
  final String comment;
  final DateTime? createdAt;

  CommentModel({
    this.id,
    required this.heroId,
    required this.name,
    required this.comment,
    this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      heroId: json['hero_id'] != null
          ? int.tryParse(json['hero_id'].toString()) ?? 0
          : 0,
      name: json['name'] ?? '',
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hero_id': heroId,
      'name': name,
      'comment': comment,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      heroId: map['post_id'] ?? map['hero_id'] ?? 0,
      name: map['username'] ?? map['name'] ?? '',
      comment: map['content'] ?? map['comment'] ?? '',
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hero_id': heroId,
      'name': name,
      'comment': comment,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
