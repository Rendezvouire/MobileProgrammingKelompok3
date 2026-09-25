import 'package:flutter/material.dart';
import '../models/comment_model.dart';
import '../services/database_helper.dart';
import '../widgets/comment_item.dart';

class CommentScreen extends StatefulWidget {
  final int postId;
  final String heroName;

  const CommentScreen({
    Key? key,
    required this.postId,
    required this.heroName,
  }) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<CommentModel> _comments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    setState(() => _isLoading = true);
    final data =
        await DatabaseHelper.instance.getCommentsByPostId(widget.postId);
    setState(() {
      _comments = data.map((e) => CommentModel.fromMap(e)).toList();
      _isLoading = false;
    });
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    await DatabaseHelper.instance.insertComment(
      widget.postId,
      "Pengguna",
      text,
    );

    _commentController.clear();
    FocusScope.of(context).unfocus();
    _loadComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Komentar - ${widget.heroName}"),
      ),
      body: Column(
        children: [
          // DAFTAR KOMENTAR
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _comments.isEmpty
                    ? const Center(
                        child: Text(
                          "Belum ada komentar.\nJadilah yang pertama berkomentar!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          return CommentItem(comment: _comments[index]);
                        },
                      ),
          ),

          const Divider(height: 1),

          // KOLOM INPUT KOMENTAR
          SafeArea(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              color: Theme.of(context).cardColor,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: "Tulis komentar...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _submitComment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
