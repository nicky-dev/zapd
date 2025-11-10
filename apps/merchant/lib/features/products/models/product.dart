import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// NIP-15 Product Model (kind 30018)
/// Base implementation following NIP-15 spec with food delivery extensions
@freezed
class Product with _$Product {
  const factory Product({
    // NIP-15 Core Fields
    required String id, // d tag - merchant generated ID
    required String stallId, // stall_id reference
    required String name, // product name
    String? description, // product description (optional per NIP-15)
    @Default([]) List<String> images, // array of image URLs (optional)
    required String currency, // currency used (must match stall currency typically)
    required double price, // cost of product (using double for NIP-15 float)
    int? quantity, // available items (null = unlimited like digital items)
    @Default([]) List<ProductSpec> specs, // array of [key, value] specifications
    @Default([]) List<ProductShipping> shipping, // extra shipping costs per zone
    
    // Food Delivery Extensions (can be stored in specs or as tags)
    @Default([]) List<String> categories, // t tags: food, fruits, main-dish, etc.
    int? spicyLevel, // 0-5 for food (stored in specs)
    int? preparationTime, // item-specific prep time in minutes (stored in specs)
    int? dailyLimit, // max units per day (stored in specs)
    bool? available, // current availability toggle (stored in specs or tags)
    
    // Metadata (not in event content, derived from event)
    String? eventId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  // Helper for creating empty product
  factory Product.empty({required String stallId}) {
    return Product(
      id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
      stallId: stallId,
      name: '',
      currency: 'BTC',
      price: 0.0,
      available: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

/// NIP-15 Product Specification
/// Key-value pairs for structured product attributes
/// Example: ["operating_system", "Android 12.0"], ["screen_size", "6.4 inches"]
@freezed
class ProductSpec with _$ProductSpec {
  const factory ProductSpec({
    required String key,
    required String value,
  }) = _ProductSpec;

  factory ProductSpec.fromJson(Map<String, dynamic> json) =>
      _$ProductSpecFromJson(json);
}

/// NIP-15 Product Shipping
/// Extra shipping costs per zone for products requiring special shipping
@freezed
class ProductShipping with _$ProductShipping {
  const factory ProductShipping({
    required String id, // must match a shipping zone ID from the stall
    required double cost, // extra cost to add to base shipping cost
  }) = _ProductShipping;

  factory ProductShipping.fromJson(Map<String, dynamic> json) =>
      _$ProductShippingFromJson(json);
}
