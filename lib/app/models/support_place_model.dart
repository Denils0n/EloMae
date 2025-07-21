class SupportPlace {
  final String placeId;
  final String name;
  final double latitude;
  final double longitude;

  final String? address;
  final String? phoneNumber;
  final bool? openNow;
  final List<String>? openingHours;
  final double? rating;
  final int? userRatingsTotal;
  final String? website;
  final String? photoUrl;

  SupportPlace({
    required this.placeId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    this.phoneNumber,
    this.openNow,
    this.openingHours,
    this.rating,
    this.userRatingsTotal,
    this.website,
    this.photoUrl,
  });

  factory SupportPlace.fromJson(Map<String, dynamic> json) {
    final location = json['geometry']['location'];
    final openingHoursJson = json['opening_hours'];

    // Tratando lista de strings para horário de funcionamento
    final openingHours = openingHoursJson != null && openingHoursJson['weekday_text'] != null
        ? List<String>.from(openingHoursJson['weekday_text'])
        : null;

    // Tratando foto
    String? photoUrl;
    if (json['photos'] != null && json['photos'].isNotEmpty) {
      final photoRef = json['photos'][0]['photo_reference'];
      photoUrl =
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoRef&key=YOUR_API_KEY';
    }

    return SupportPlace(
      placeId: json['place_id'],
      name: json['name'],
      latitude: location['lat'],
      longitude: location['lng'],
      address: json['formatted_address'] ?? json['vicinity'],
      phoneNumber: json['formatted_phone_number'],
      openNow: openingHoursJson != null ? openingHoursJson['open_now'] : null,
      openingHours: openingHours,
      rating: (json['rating'] != null) ? (json['rating'] as num).toDouble() : null,
      userRatingsTotal: json['user_ratings_total'],
      website: json['website'],
      photoUrl: photoUrl,
    );
  }
}

