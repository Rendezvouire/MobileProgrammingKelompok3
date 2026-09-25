class HeroModel {
  final String id;
  final String name;
  final String fullName;
  final String subtitle;
  final String image;
  final String origin;
  final String birthDeath;
  final String biography;

  HeroModel({
    required this.id,
    required this.name,
    required this.fullName,
    required this.subtitle,
    required this.image,
    required this.origin,
    required this.birthDeath,
    required this.biography,
  });

  // JSON -> objek (untuk MENAMPILKAN data)
  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      origin: json['origin']?.toString() ?? '',
      birthDeath: json['birth_death']?.toString() ?? '',
      biography: json['biography']?.toString() ?? '',
    );
  }

  // objek -> JSON (untuk MENGIRIM data saat tambah / edit)  ← INI YANG BARU
  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'full_name': fullName,
      'subtitle': subtitle,
      'image': image,
      'origin': origin,
      'birth_death': birthDeath,
      'biography': biography,
    };
  }
}