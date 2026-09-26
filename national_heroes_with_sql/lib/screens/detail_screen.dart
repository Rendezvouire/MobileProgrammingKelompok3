import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/hero_model.dart';
import '../models/comment_model.dart';
import '../services/api_service.dart';
import '../widgets/comment_item.dart';

class DetailScreen extends StatefulWidget {
  final HeroModel hero;

  const DetailScreen({
    super.key,
    required this.hero,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final name = _nameController.text.trim();
    final commentText = _commentController.text.trim();
    final heroIdInt = int.tryParse(widget.hero.id) ?? 0;

    if (name.isEmpty || commentText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan komentar tidak boleh kosong!')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final newComment = CommentModel(
        heroId: heroIdInt,
        name: name,
        comment: commentText,
      );
      await ApiService.addComment(newComment);
      _nameController.clear();
      _commentController.clear();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Komentar berhasil dikirim!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim komentar: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final heroIdInt = int.tryParse(widget.hero.id) ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF234E32),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Tokoh',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'TOKOH PAHLAWAN',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.2,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.white),
            tooltip: 'Salin Informasi',
            onPressed: () {
              final String textToCopy =
                  '${widget.hero.name} (${widget.hero.birthDeath})\n'
                  '${widget.hero.subtitle}\n\n'
                  'Daerah Asal: ${widget.hero.origin}\n\n'
                  'Biografi:\n${widget.hero.biography}';

              Clipboard.setData(ClipboardData(text: textToCopy));

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Informasi ${widget.hero.name} berhasil disalin!'),
                  backgroundColor: const Color(0xFF234E32),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            tooltip: 'Bagikan Pahlawan',
            onPressed: () {
              final String shareMessage = 'Mengenang jasa pahlawan nasional:\n'
                  '*${widget.hero.name}* (${widget.hero.birthDeath})\n'
                  '${widget.hero.subtitle}\n\n'
                  'Daerah Asal: ${widget.hero.origin}\n\n'
                  'Singkat Cerita:\n${widget.hero.biography}\n\n'
                  'Yuk kenali lebih banyak pahlawan Indonesia melalui aplikasi National Heroes!';

              Share.share(shareMessage);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.brown.withValues(alpha: 0.2),
                        width: 6,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: widget.hero.image.startsWith('http')
                          ? Image.network(
                              widget.hero.image,
                              height: 320,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(
                                height: 320,
                                child:
                                    Center(child: Icon(Icons.error, size: 50)),
                              ),
                            )
                          : Image.asset(
                              widget.hero.image,
                              height: 320,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(
                                height: 320,
                                child:
                                    Center(child: Icon(Icons.error, size: 50)),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'PAHLAWAN KEMERDEKAAN NASIONAL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.hero.name,
                    style: const TextStyle(
                      fontFamily: 'Serif',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C221E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (widget.hero.subtitle.isNotEmpty) ...[
                    Text(
                      widget.hero.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF234E32),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (widget.hero.fullName.isNotEmpty) ...[
                    Text(
                      widget.hero.fullName,
                      style: const TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: Icons.location_on_outlined,
              iconBgColor: const Color(0xFFD8F3DC),
              title: 'DAERAH ASAL',
              content: widget.hero.origin,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.calendar_today_outlined,
              iconBgColor: const Color(0xFFFFE8D6),
              title: 'MASA HIDUP',
              content: widget.hero.birthDeath,
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF234E32),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.menu_book,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Biografi & Perjalanan\nPerjuangan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C221E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.hero.biography,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE8D6),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Diskusi & Komentar Tokoh',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C221E),
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<CommentModel>>(
              future: ApiService.getComments(heroIdInt),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Gagal memuat komentar: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text(
                      'Belum ada komentar untuk tokoh ini. Jadilah yang pertama berkomentar!');
                }

                final comments = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return CommentItem(comment: comments[index]);
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tulis Komentar / Ulasan',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Anda',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Komentar',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF234E32),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _isSubmitting ? null : _submitComment,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Kirim Komentar'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF234E32), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C221E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
