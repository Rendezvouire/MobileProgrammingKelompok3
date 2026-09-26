import 'package:flutter/material.dart';
import '../models/comment_model.dart';

class CommentItem extends StatelessWidget {
  final CommentModel comment;

  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    // Format waktu aman dari null
    String timeString = '';
    if (comment.createdAt != null) {
      final hour = comment.createdAt!.hour.toString().padLeft(2, '0');
      final minute = comment.createdAt!.minute.toString().padLeft(2, '0');
      timeString = '$hour:$minute';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                comment.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                timeString,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            comment.comment,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
