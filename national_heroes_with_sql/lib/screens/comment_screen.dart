import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/comment_model.dart';

class CommentScreen extends StatefulWidget {
  final int postId;

  const CommentScreen({Key? key, required this.postId}) : super(key: key);

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

  // 1. Memuat komentar dari Database
  Future<void> _loadComments() async {
    setState(() => _isLoading = true);
    final data =
        await DatabaseHelper.instance.getCommentsByPostId(widget.postId);
    setState(() {
      _comments = data.map((e) => CommentModel.fromMap(e)).toList();
      _isLoading = false;
    });
  }

  // 2. Menyimpan komentar baru
  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    // Simpan ke DB (Username bisa disesuaikan dengan user yang login)
    await DatabaseHelper.instance.insertComment(
      widget.postId,
      "Pengguna",
      text,
    );

    _commentController.clear();
    _loadComments(); // Refresh list setelah simpan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Komentar"),
      ),
      body: Column(
        children: [
          // DAFTAR KOMENTAR
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _comments.isEmpty
                    ? const Center(child: Text("Belum ada komentar."))
                    : ListView.builder(
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final item = _comments[index];
                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(item.username),
                            subtitle: Text(item.content),
                            trailing: Text(
                              "${item.createdAt.hour}:${item.createdAt.minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          );
                        },
                      ),
          ),

          const Divider(height: 1),

          // INPUT FIELD KOMENTAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Tulis komentar...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _submitComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
