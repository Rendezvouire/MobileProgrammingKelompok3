import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/hero_model.dart';

class _C {
  static const primary = Color(0xFF387B66); // Viridian
  static const primaryDark = Color(0xFF2E6654); // garis bawah AppBar
  static const primaryTint = Color(0xFFDCEDE6); // latar ikon fakta
  static const secondary = Color(0xFFFFCB82); // Sunset
  static const secondarySoft = Color(0xFFFFDDB2); // subjudul AppBar
  static const onSecondary = Color(0xFF785215);
  static const canvas = Color(0xFFFAF5EC); // latar halaman
  static const container = Color(0xFFF4EFE6); // tombol netral
  static const outline = Color(0xFFEBE1D2); // border kartu
  static const bistre = Color(0xFF381E05); // teks utama
  static const bistreMuted = Color(0xFF675038); // teks label
  static const shadow = Color(0x0F381E05); // bistre 6%
  static const accent = Color(0x66FDC980); // sudut dekoratif kartu biografi
}


TextStyle _serif(
  double size, {
  FontWeight weight = FontWeight.w600,
  Color color = _C.bistre,
  double? height,
}) =>
    GoogleFonts.playfairDisplay(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );

TextStyle _sans(
  double size, {
  FontWeight weight = FontWeight.w400,
  Color color = _C.bistre,
  double? height,
  double? letterSpacing,
}) =>
    GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );

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
  // Hanya tampilan (belum disimpan permanen).
  bool _bookmarked = false;


  String get _lifespanLabel {
    final hero = widget.hero;
    final match = RegExp(r'(\d{4})\D+(\d{4})').firstMatch(hero.birthDeath);
    if (match == null) return hero.birthDeath;
    final age = int.parse(match.group(2)!) - int.parse(match.group(1)!);
    return '${hero.birthDeath} ($age Tahun)';
  }

  Future<void> _share() async {
    final hero = widget.hero;
    await Clipboard.setData(
      ClipboardData(
        text: '${hero.name}\n'
            'Daerah asal: ${hero.origin}\n'
            'Masa hidup: ${hero.birthDeath}\n\n'
            '${hero.biography}',
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: _C.bistre,
        content: Text('Profil ${hero.name} disalin ke clipboard'),
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _C.outline),
        boxShadow: const [
          BoxShadow(
            color: _C.shadow,
            blurRadius: 16,
            spreadRadius: -2,
            offset: Offset(0, 4),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.canvas,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActionBar(),
              const SizedBox(height: 8),
              _buildPortraitCard(),
              const SizedBox(height: 16),
              _buildFactCard(
                icon: Icons.location_on_outlined,
                label: 'Daerah Asal',
                value: widget.hero.origin,
              ),
              const SizedBox(height: 12),
              _buildFactCard(
                icon: Icons.calendar_month_outlined,
                label: 'Masa Hidup',
                value: _lifespanLabel,
              ),
              const SizedBox(height: 16),
              _buildBiographyCard(),
            ],
          ),
        ),
      ),
    );
  }


  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _C.primary,
      foregroundColor: _C.canvas,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 80,
      titleSpacing: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      shape: const Border(bottom: BorderSide(color: _C.primaryDark)),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detail Tokoh', style: _serif(18, color: _C.canvas)),
          const SizedBox(height: 2),
          Text(
            'TOKOH PAHLAWAN',
            style: _sans(
              11,
              weight: FontWeight.w700,
              color: _C.secondarySoft,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () => Navigator.of(context).maybePop(),
          style: TextButton.styleFrom(
            foregroundColor: _C.bistre,
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          icon: const Icon(Icons.arrow_back, size: 20, color: _C.primary),
          label: Text(
            'KEMBALI KE GALERI',
            style: _sans(
              12,
              weight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Bagikan',
          onPressed: _share,
          style: IconButton.styleFrom(
            backgroundColor: _C.container,
            foregroundColor: _C.primary,
            fixedSize: const Size(48, 48),
          ),
          icon: const Icon(Icons.share_outlined, size: 22),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: 'Simpan',
          onPressed: () => setState(() => _bookmarked = !_bookmarked),
          style: IconButton.styleFrom(
            backgroundColor: _bookmarked ? _C.secondary : _C.container,
            foregroundColor: _bookmarked ? _C.onSecondary : _C.bistreMuted,
            fixedSize: const Size(48, 48),
          ),
          icon: Icon(
            _bookmarked ? Icons.star : Icons.star_border,
            size: 22,
          ),
        ),
      ],
    );
  }


  Widget _buildPortraitCard() {
    final hero = widget.hero;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 4 / 5,
              child: Image.asset(
                hero.image,
                fit: BoxFit.cover,
                // Kepala tokoh ada di bagian atas foto, jadi crop dari atas.
                alignment: Alignment.topCenter,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: _C.container,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 64,
                    color: _C.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'PAHLAWAN NASIONAL',
            style: _sans(
              11,
              weight: FontWeight.w700,
              color: _C.primary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hero.name,
            style: _serif(32, weight: FontWeight.w700, height: 1.2),
          ),
        ],
      ),
    );
  }


  Widget _buildFactCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _C.primaryTint,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 24, color: _C.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: _sans(
                    11,
                    weight: FontWeight.w700,
                    color: _C.bistreMuted,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: _sans(16, weight: FontWeight.w600, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBiographyCard() {

    final paragraphs = widget.hero.biography
        .split(RegExp(r'\n\s*\n'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    return Container(
      width: double.infinity,
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            width: 6,
            child: ColoredBox(color: _C.primary),
          ),
          const Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              width: 48,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _C.accent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(48),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(26, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: _C.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_stories,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Biografi & Perjalanan Perjuangan',
                        style: _serif(18, height: 1.3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                for (int i = 0; i < paragraphs.length; i++) ...[
                  if (i > 0) const SizedBox(height: 14),
                  Text(
                    paragraphs[i],
                    style: _sans(15, height: 1.65),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
