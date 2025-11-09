import 'package:equatable/equatable.dart';

/// User model
class User extends Equatable {
  final String pubkey; // Nostr public key
  final String name;
  final String? avatarUrl;
  final UserRole role;
  final String? phoneNumber; // Encrypted
  final DateTime createdAt;

  const User({
    required this.pubkey,
    required this.name,
    this.avatarUrl,
    required this.role,
    this.phoneNumber,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [pubkey, name, avatarUrl, role, phoneNumber, createdAt];

  Map<String, dynamic> toJson() => {
        'pubkey': pubkey,
        'name': name,
        'avatarUrl': avatarUrl,
        'role': role.name,
        'phoneNumber': phoneNumber,
        'createdAt': createdAt.toIso8601String(),
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      pubkey: json['pubkey'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      role: UserRole.values.byName(json['role']),
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

/// User role
enum UserRole {
  customer,
  merchant,
  rider,
}
