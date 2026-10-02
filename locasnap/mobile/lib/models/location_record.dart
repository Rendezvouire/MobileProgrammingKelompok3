class LocationRecord {
  final int? id;
  final String title;
  final String? description;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final DateTime? createdAt;

  const LocationRecord({
    this.id,
    required this.title,
    this.description,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    this.createdAt,
  });

  factory LocationRecord.fromJson(Map<String, dynamic> json) {
    return LocationRecord(
      id: json['id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}
