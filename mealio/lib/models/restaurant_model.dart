class RestaurantModel {
  final String id;
  final String name;
  final String address;

  final double latitude;
  final double longitude;

  final String locationUrl;

  final bool isHalal;
  final bool isVegan;

  final int startingPrice;

  final double rating;
  final int ratingCount;

  final List<String> tags;
  final List<String> signatureDishes;

  final String imageUrl;

  final double distanceKm;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.address,

    required this.latitude,
    required this.longitude,

    required this.locationUrl,

    required this.isHalal,
    required this.isVegan,

    required this.startingPrice,

    required this.rating,
    required this.ratingCount,

    required this.tags,
    required this.signatureDishes,

    required this.imageUrl,

    required this.distanceKm,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json["id"],

      name: json["name"],
      address: json["address"],

      latitude: (json["latitude"]).toDouble(),

      longitude: (json["longitude"]).toDouble(),

      locationUrl: json["locationUrl"],

      isHalal: json["isHalal"],

      isVegan: json["isVegan"],

      startingPrice: json["startingPrice"],

      rating: (json["rating"]).toDouble(),

      ratingCount: json["ratingCount"],

      tags: List<String>.from(json["tags"]),

      signatureDishes: List<String>.from(json["signatureDishes"]),

      imageUrl: json["imageUrl"] ?? "",

      distanceKm: (json["distanceKm"] ?? 0).toDouble(),
    );
  }
}
