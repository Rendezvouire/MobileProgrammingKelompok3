class CommentModel {
  final int? id;
  final int heroId;
  final String name;
  final String comment;
  final DateTime createdAt;

  CommentModel({
    this.id,
    required this.heroId,
    required this.name,
    required this.comment,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      heroId: json['post_id'],
      name: json['username'],
      comment: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': heroId,
      'username': name,
      'content': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
