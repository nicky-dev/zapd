import 'package:equatable/equatable.dart';

/// Restaurant model
class Restaurant extends Equatable {
  final String id;
  final String pubkey; // Nostr public key
  final String name;
  final String description;
  final String imageUrl;
  final RestaurantLocation location;
  final List<String> categories;
  final double rating;
  final int reviewCount;
  final bool isOpen;
  final String phoneNumber; // Encrypted in Nostr events
  final RestaurantHours hours;

  const Restaurant({
    required this.id,
    required this.pubkey,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.categories,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isOpen = false,
    required this.phoneNumber,
    required this.hours,
  });

  @override
  List<Object?> get props => [
        id,
        pubkey,
        name,
        description,
        imageUrl,
        location,
        categories,
        rating,
        reviewCount,
        isOpen,
        phoneNumber,
        hours,
      ];

  Restaurant copyWith({
    String? id,
    String? pubkey,
    String? name,
    String? description,
    String? imageUrl,
    RestaurantLocation? location,
    List<String>? categories,
    double? rating,
    int? reviewCount,
    bool? isOpen,
    String? phoneNumber,
    RestaurantHours? hours,
  }) {
    return Restaurant(
      id: id ?? this.id,
      pubkey: pubkey ?? this.pubkey,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      categories: categories ?? this.categories,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isOpen: isOpen ?? this.isOpen,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      hours: hours ?? this.hours,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pubkey': pubkey,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'location': location.toJson(),
        'categories': categories,
        'rating': rating,
        'reviewCount': reviewCount,
        'isOpen': isOpen,
        'phoneNumber': phoneNumber,
        'hours': hours.toJson(),
      };

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      pubkey: json['pubkey'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      location: RestaurantLocation.fromJson(json['location']),
      categories: List<String>.from(json['categories']),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      isOpen: json['isOpen'] as bool,
      phoneNumber: json['phoneNumber'] as String,
      hours: RestaurantHours.fromJson(json['hours']),
    );
  }
}

/// Restaurant location
class RestaurantLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String country;

  const RestaurantLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.country,
  });

  @override
  List<Object?> get props => [latitude, longitude, address, city, country];

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'city': city,
        'country': country,
      };

  factory RestaurantLocation.fromJson(Map<String, dynamic> json) {
    return RestaurantLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
    );
  }
}

/// Restaurant hours
class RestaurantHours extends Equatable {
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;
  final String sunday;

  const RestaurantHours({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  @override
  List<Object?> get props => [
        monday,
        tuesday,
        wednesday,
        thursday,
        friday,
        saturday,
        sunday,
      ];

  Map<String, dynamic> toJson() => {
        'monday': monday,
        'tuesday': tuesday,
        'wednesday': wednesday,
        'thursday': thursday,
        'friday': friday,
        'saturday': saturday,
        'sunday': sunday,
      };

  factory RestaurantHours.fromJson(Map<String, dynamic> json) {
    return RestaurantHours(
      monday: json['monday'] as String,
      tuesday: json['tuesday'] as String,
      wednesday: json['wednesday'] as String,
      thursday: json['thursday'] as String,
      friday: json['friday'] as String,
      saturday: json['saturday'] as String,
      sunday: json['sunday'] as String,
    );
  }
}
