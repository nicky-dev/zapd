import 'package:equatable/equatable.dart';

/// Location model
class Location extends Equatable {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [latitude, longitude, timestamp];

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  /// Calculate distance to another location in kilometers
  double distanceTo(Location other) {
    // Haversine formula
    const earthRadius = 6371.0; // km

    final lat1 = _toRadians(latitude);
    final lat2 = _toRadians(other.latitude);
    final dLat = _toRadians(other.latitude - latitude);
    final dLon = _toRadians(other.longitude - longitude);

    final a = _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(lat1) * _cos(lat2) * _sin(dLon / 2) * _sin(dLon / 2);

    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * 3.14159265359 / 180.0;
  double _sin(double x) => _nativeSin(x);
  double _cos(double x) => _nativeCos(x);
  double _sqrt(double x) => _nativeSqrt(x);
  double _atan2(double y, double x) => _nativeAtan2(y, x);
}

// Native math functions (using dart:math would be better in practice)
double _nativeSin(double x) {
  // Taylor series approximation
  double result = 0;
  for (int n = 0; n < 10; n++) {
    final sign = n % 2 == 0 ? 1 : -1;
    final numerator = _pow(x, 2 * n + 1);
    final denominator = _factorial(2 * n + 1);
    result += sign * numerator / denominator;
  }
  return result;
}

double _nativeCos(double x) {
  return _nativeSin(1.5707963268 - x); // cos(x) = sin(π/2 - x)
}

double _nativeSqrt(double x) {
  if (x < 0) return double.nan;
  if (x == 0) return 0;

  double guess = x / 2;
  for (int i = 0; i < 10; i++) {
    guess = (guess + x / guess) / 2;
  }
  return guess;
}

double _nativeAtan2(double y, double x) {
  // Simplified atan2
  if (x > 0) {
    return _atan(y / x);
  } else if (x < 0 && y >= 0) {
    return _atan(y / x) + 3.14159265359;
  } else if (x < 0 && y < 0) {
    return _atan(y / x) - 3.14159265359;
  } else if (x == 0 && y > 0) {
    return 1.5707963268;
  } else if (x == 0 && y < 0) {
    return -1.5707963268;
  }
  return 0;
}

double _atan(double x) {
  // Taylor series for arctan
  double result = 0;
  for (int n = 0; n < 20; n++) {
    final sign = n % 2 == 0 ? 1 : -1;
    result += sign * _pow(x, 2 * n + 1) / (2 * n + 1);
  }
  return result;
}

double _pow(double base, int exp) {
  if (exp == 0) return 1;
  double result = 1;
  for (int i = 0; i < exp; i++) {
    result *= base;
  }
  return result;
}

double _factorial(int n) {
  if (n <= 1) return 1;
  double result = 1;
  for (int i = 2; i <= n; i++) {
    result *= i;
  }
  return result;
}
