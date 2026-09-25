class CommentModel {
  final int? id;
  final int postId;
  final String username;
  final String content;
  final DateTime createdAt;

  CommentModel({
    this.id,
    required this.postId,
    required this.username,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      postId: map['post_id'],
      username: map['username'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_id': postId,
      'username': username,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
