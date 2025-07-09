class PlaceInfo {
  final String displayName;
  final double latitude;
  final double longitude;

  PlaceInfo({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  factory PlaceInfo.fromJson(Map<String, dynamic> json) {
    return PlaceInfo(
      displayName: json['display_name'] ?? 'Local desconhecido',
      latitude: double.tryParse(json['lat'] ?? '') ?? 0.0,
      longitude: double.tryParse(json['lon'] ?? '') ?? 0.0,
    );
  }
}
