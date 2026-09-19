class HeroModel {
  final String name;
  final String image;
  final String origin;
  final String birthDeath;
  final String biography;
  final String? subtitle;
  final String? fullName;

  HeroModel({
    required this.name,
    required this.image,
    required this.origin,
    required this.birthDeath,
    required this.biography,
    this.subtitle,
    this.fullName,
  });
}
