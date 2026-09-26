import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/api_service.dart'; // Diubah untuk ambil dari API/Database
import '../models/hero_model.dart';
import '../utils/app_colors.dart';
import 'detail_screen.dart';

const Map<String, String> _taglines = {
  'assets/images/kartini.jpg': 'Pelopor Emansipasi & Pendidikan Wanita',
  'assets/images/diponegoro.jpg': 'Pemimpin Perang Jawa (1825–1830)',
  'assets/images/ki_hajar.jpg': 'Bapak Pendidikan Nasional',
  'assets/images/cut_nyak_dien.jpg': 'Srikandi Pejuang Perang Aceh',
  'assets/images/cut_nyak_meutia.jpg': 'Srikandi Perlawanan Kolonial',
  'assets/images/imam_bonjol.jpg': 'Pemimpin Perang Padri',
  'assets/images/pattimura.jpg': 'Pahlawan Perlawanan Maluku',
  'assets/images/sultan_hasannudin.jpg': 'Ayam Jantan dari Timur',
  'assets/images/sudirman.jpg': 'Panglima Besar TKR & Pejuang Gerilya',
  'assets/images/bung_tomo.jpg': 'Pengobar Semangat 10 November',
  'assets/images/dr_sutomo.jpg': 'Pendiri Organisasi Budi Utomo',
  'assets/images/ahmad_yani.jpg': 'Pahlawan Revolusi Indonesia',
  'assets/images/otto_iskandardinata.jpg': 'Si Jalak Harupat & Tokoh BPUPKI',
  'assets/images/ngurah_rai.jpg': 'Pemimpin Puputan Margarana',
  'assets/images/martha_tiahahu.jpg': 'Gadis Pejuang Laut Banda',
};

const double _cardTextHeight = 118;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetSearch() {
    _controller.clear();
    FocusScope.of(context).unfocus();
    setState(() => _query = '');
  }

  void _openDetail(HeroModel hero) {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailScreen(hero: hero)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: _buildAppBar(),
      body: FutureBuilder<List<HeroModel>>(
        future: ApiService
            .getHeroes(), // Mengambil data langsung dari Database MySQL via API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Gagal memuat data:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada data pahlawan.'));
          }

          final rawHeroes = snapshot.data!;

          // Urutkan sesuai taglines asli kelompokmu
          final order = _taglines.keys.toList();
          int rank(HeroModel hero) {
            final i = order.indexOf(hero.image);
            return i < 0 ? order.length : i;
          }

          final ordered = [...rawHeroes]
            ..sort((a, b) => rank(a).compareTo(rank(b)));

          // Filter pencarian
          final q = _query.trim().toLowerCase();
          final list = q.isEmpty
              ? ordered
              : ordered.where((hero) {
                  return hero.name.toLowerCase().contains(q) ||
                      hero.origin.toLowerCase().contains(q) ||
                      (_taglines[hero.image] ?? '').toLowerCase().contains(q);
                }).toList();

          return CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                  child: Text(
                    'Arsip Tokoh Bangsa',
                    style:
                        AppText.serif(32, weight: FontWeight.w700, height: 1.2),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SearchHeaderDelegate(child: _buildSearchField()),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'GALERI PORTRET',
                        style: AppText.sans(
                          11,
                          weight: FontWeight.w700,
                          color: AppColors.bistreMuted,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        '${list.length} Tokoh Ditampilkan',
                        style: AppText.sans(
                          11,
                          weight: FontWeight.w700,
                          color: AppColors.secondaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (list.isEmpty)
                SliverToBoxAdapter(child: _buildEmptyState())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = (constraints.crossAxisExtent - 14) / 2;
                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          mainAxisExtent: cardWidth * 4 / 3 + _cardTextHeight,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final hero = list[i];
                            return _HeroGalleryCard(
                              hero: hero,
                              number: ordered.indexOf(hero) + 1,
                              province: hero.origin.split(',').last.trim(),
                              tagline: _taglines[hero.image],
                              onTap: () => _openDetail(hero),
                            );
                          },
                          childCount: list.length,
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 80,
      titleSpacing: 20,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOKOH PAHLAWAN',
            style: AppText.serif(18, color: AppColors.secondary),
          ),
          const SizedBox(height: 2),
          Text(
            'GALERI MUSEUM DIGITAL',
            style: AppText.sans(
              11,
              weight: FontWeight.w700,
              color: const Color(0xD9FFF2EA),
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color, width: width),
        );

    return SizedBox(
      height: 48,
      child: TextField(
        controller: _controller,
        onChanged: (value) => setState(() => _query = value),
        textAlignVertical: TextAlignVertical.center,
        cursorColor: AppColors.primary,
        style: AppText.sans(14),
        decoration: InputDecoration(
          hintText: 'Cari kata kunci tentang pahlawan...',
          hintStyle: AppText.sans(
            14,
            color: AppColors.bistre.withAlpha(115),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          prefixIcon: const Icon(
            Icons.search,
            size: 22,
            color: AppColors.primary,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 46,
            minHeight: 48,
          ),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Hapus pencarian',
                  onPressed: _resetSearch,
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.bistreMuted,
                  ),
                ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 46,
            minHeight: 48,
          ),
          border: border(AppColors.outline),
          enabledBorder: border(AppColors.outline),
          focusedBorder: border(AppColors.primary, 2),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final highlight = AppText.sans(
      14,
      weight: FontWeight.w700,
      color: AppColors.primary,
      height: 1.6,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 40, 32, 48),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.manage_search,
              size: 32,
              color: AppColors.onSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pahlawan Tidak Ditemukan',
            textAlign: TextAlign.center,
            style: AppText.serif(18),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              style: AppText.sans(
                14,
                color: AppColors.bistreMuted,
                height: 1.6,
              ),
              children: [
                const TextSpan(text: 'Coba gunakan kata kunci lain seperti '),
                TextSpan(text: 'Kartini', style: highlight),
                const TextSpan(text: ', '),
                TextSpan(text: 'Sudirman', style: highlight),
                const TextSpan(text: ', atau '),
                TextSpan(text: 'Diponegoro', style: highlight),
                const TextSpan(text: '.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _resetSearch,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(
              'Kembalikan Semua Pahlawan',
              style: AppText.sans(
                14,
                weight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SearchHeaderDelegate({required this.child});

  @override
  double get minExtent => 64;

  @override
  double get maxExtent => 64;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.canvas,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _SearchHeaderDelegate oldDelegate) => true;
}

class _HeroGalleryCard extends StatelessWidget {
  final HeroModel hero;
  final int number;
  final String province;
  final String? tagline;
  final VoidCallback onTap;

  const _HeroGalleryCard({
    required this.hero,
    required this.number,
    required this.province,
    required this.tagline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x12381E05),
            blurRadius: 18,
            spreadRadius: -2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: const BorderSide(color: AppColors.outline),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 3 / 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Mendukung gambar dari URL database atau asset lokal
                    hero.image.startsWith('http')
                        ? Image.network(
                            hero.image,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: AppColors.container,
                              alignment: Alignment.center,
                              child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 40,
                                  color: AppColors.primary),
                            ),
                          )
                        : Image.asset(
                            hero.image,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: AppColors.container,
                              alignment: Alignment.center,
                              child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 40,
                                  color: AppColors.primary),
                            ),
                          ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [Color(0x99000000), Color(0x00000000)],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xB3381E05),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '#${number.toString().padLeft(2, '0')}',
                          style: AppText.sans(
                            11,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 10,
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                province,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.sans(
                                  11,
                                  weight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hero.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.serif(
                          18,
                          weight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hero.birthDeath,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.sans(
                          11,
                          weight: FontWeight.w600,
                          color: AppColors.onSecondary,
                        ),
                      ),
                      if (tagline != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          tagline!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.sans(
                            12,
                            color: AppColors.bistreSoft,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
