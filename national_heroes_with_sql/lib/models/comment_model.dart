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

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      heroId: map['post_id'],
      name: map['username'],
      comment: map['content'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_id': heroId,
      'username': name,
      'content': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
