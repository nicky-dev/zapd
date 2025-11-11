import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nostr_core/nostr_core.dart';
import '../models/product.dart';

/// Repository for managing Products using NIP-15 (kind 30018)
class ProductRepository {
  final NostrClient nostrClient;
  final String merchantPubkey;

  ProductRepository({
    required this.nostrClient,
    required this.merchantPubkey,
  });

  /// Sign an unsigned event with private key
  NostrEvent _signEvent(NostrEvent unsignedEvent, String privateKey) {
    final signature = Schnorr.sign(unsignedEvent.id, privateKey);
    return NostrEvent(
      id: unsignedEvent.id,
      pubkey: unsignedEvent.pubkey,
      createdAt: unsignedEvent.createdAt,
      kind: unsignedEvent.kind,
      tags: unsignedEvent.tags,
      content: unsignedEvent.content,
      sig: signature,
    );
  }

  /// Create or update a product (kind 30018)
  Future<String> saveProduct({
    required Product product,
    required String privateKey,
  }) async {
    // NIP-15 required fields in content
    final contentData = <String, dynamic>{
      'id': product.id,
      'stall_id': product.stallId,
      'name': product.name,
      'images': product.images,
      'currency': product.currency,
      'price': product.price, // double as per spec
    };

    // Optional description
    if (product.description != null && product.description!.isNotEmpty) {
      contentData['description'] = product.description!;
    }

    // Optional quantity (null means unlimited per spec)
    if (product.quantity != null) {
      contentData['quantity'] = product.quantity!;
    }

    // NIP-15 specs array
    contentData['specs'] = product.specs.map((spec) => [spec.key, spec.value]).toList();

    // NIP-15 shipping array (zone-specific costs)
    contentData['shipping'] = product.shipping.map((s) => {
      'id': s.id,
      'cost': s.cost,
    }).toList();

    final tags = <List<String>>[
      ['d', product.id], // NIP-15 required: unique identifier
    ];

    // Extension fields for food delivery
    if (product.spicyLevel != null) {
      tags.add(['spicy_level', product.spicyLevel.toString()]);
    }

    if (product.preparationTime != null) {
      tags.add(['preparation_time', product.preparationTime.toString()]);
    }

    if (product.dailyLimit != null) {
      tags.add(['daily_limit', product.dailyLimit.toString()]);
    }

    // Categories for filtering
    for (final category in product.categories) {
      tags.add(['category', category]);
    }

    tags.add(['available', product.available.toString()]);

    // Build unsigned event
    final unsignedEvent = EventBuilder()
        .pubkey(merchantPubkey)
        .kind(30018) // NIP-15 Product
        .content(jsonEncode(contentData))
        .addTags(tags)
        .build();

    // Sign and publish
    final signedEvent = _signEvent(unsignedEvent, privateKey);
    await nostrClient.publish(signedEvent);

    return signedEvent.id;
  }

  /// Fetch all products for a stall
  Future<List<Product>> fetchProductsByStall(String stallId) async {
    final filter = NostrFilter(
      kinds: const [30018],
      authors: [merchantPubkey],
      tags: {'stall_id': [stallId]},
    );

    final subscription = nostrClient.subscribe([filter]);
    final events = <NostrEvent>[];

    // Collect events for 3 seconds
    await for (final event in subscription.stream.timeout(
      const Duration(seconds: 3),
      onTimeout: (sink) => sink.close(),
    )) {
      events.add(event);
    }

    subscription.onClose();
    
    // Group events by 'd' tag (product ID) and keep only the latest one
    final productMap = <String, NostrEvent>{};
    for (final event in events) {
      // Find 'd' tag
      final dTag = event.tags.firstWhere(
        (tag) => tag.isNotEmpty && tag[0] == 'd',
        orElse: () => [],
      );
      
      if (dTag.length >= 2) {
        final productId = dTag[1];
        final existing = productMap[productId];
        
        // Keep the event with the latest createdAt timestamp
        if (existing == null || event.createdAt > existing.createdAt) {
          productMap[productId] = event;
        }
      }
    }
    
    // Convert unique events to Product objects
    // Filter out deleted products (empty content)
    return productMap.values
        .where((event) => event.content.isNotEmpty) // Skip deleted products
        .map(_eventToProduct)
        .where((p) => p != null)
        .cast<Product>()
        .toList();
  }

  /// Fetch a single product by ID
  Future<Product?> fetchProductById(String productId) async {
    final filter = NostrFilter(
      kinds: const [30018],
      authors: [merchantPubkey],
      tags: {'d': [productId]},
    );

    final subscription = nostrClient.subscribe([filter]);
    Product? result;

    await for (final event in subscription.stream.timeout(
      const Duration(seconds: 2),
      onTimeout: (sink) => sink.close(),
    )) {
      result = _eventToProduct(event);
      if (result != null) break;
    }

    subscription.onClose();
    return result;
  }

  /// Duplicate a product with a new ID
  Product duplicateProduct(Product original) {
    final newId = _generateProductId();
    return original.copyWith(
      id: newId,
      name: '${original.name} (Copy)',
      eventId: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Delete a product (publish deletion event NIP-09)
  /// Delete a product by publishing an empty replacement event
  /// NIP-15: For Parameterized Replaceable Events, publish empty content to delete
  Future<void> deleteProduct({
    required String productId,
    required String privateKey,
  }) async {
    // NIP-33: Delete by publishing a replacement event with empty content
    final unsignedEvent = EventBuilder()
        .pubkey(merchantPubkey)
        .kind(30018) // Same kind as product
        .content('') // Empty content means deleted
        .addTag(['d', productId]) // Same identifier
        .build();

    final signedEvent = _signEvent(unsignedEvent, privateKey);
    await nostrClient.publish(signedEvent);
  }

  /// Update product availability (quick toggle)
  Future<String> toggleAvailability({
    required Product product,
    required String privateKey,
  }) async {
    return saveProduct(
      product: product.copyWith(available: !(product.available ?? true)),
      privateKey: privateKey,
    );
  }

  /// Convert NostrEvent to Product model
  Product? _eventToProduct(NostrEvent event) {
    try {
      final content = jsonDecode(event.content) as Map<String, dynamic>;

      // Create a map of tags
      final tagMap = <String, List<String>>{};

      for (final tag in event.tags) {
        if (tag.isEmpty) continue;
        final key = tag[0];
        final values = tag.skip(1).toList();
        
        if (tagMap.containsKey(key)) {
          tagMap[key]!.addAll(values);
        } else {
          tagMap[key] = values;
        }
      }

      // Parse NIP-15 specs array from content
      final specsList = (content['specs'] as List<dynamic>?) ?? [];
      final specs = specsList.map((s) {
        final specPair = s as List<dynamic>;
        return ProductSpec(
          key: specPair[0] as String,
          value: specPair[1] as String,
        );
      }).toList();

      // Parse NIP-15 shipping array from content
      final shippingList = (content['shipping'] as List<dynamic>?) ?? [];
      final shipping = shippingList.map((s) {
        final shippingData = s as Map<String, dynamic>;
        return ProductShipping(
          id: shippingData['id'] as String,
          cost: (shippingData['cost'] as num).toDouble(),
        );
      }).toList();

      return Product(
        id: content['id'] as String? ?? tagMap['d']?.first ?? '',
        stallId: content['stall_id'] as String? ?? '',
        name: content['name'] as String? ?? '',
        description: content['description'] as String?,
        images: (content['images'] as List<dynamic>?)?.cast<String>() ?? [],
        currency: content['currency'] as String? ?? 'BTC',
        price: (content['price'] as num?)?.toDouble() ?? 0.0,
        quantity: content['quantity'] as int?,
        specs: specs,
        shipping: shipping,
        // Extension fields
        available: tagMap['available']?.first == 'true',
        categories: tagMap['category'] ?? [],
        spicyLevel: int.tryParse(tagMap['spicy_level']?.first ?? ''),
        preparationTime: int.tryParse(tagMap['preparation_time']?.first ?? ''),
        dailyLimit: int.tryParse(tagMap['daily_limit']?.first ?? ''),
      );
    } catch (e) {
      debugPrint('Error parsing product event: $e');
      return null;
    }
  }

  /// Generate unique product ID
  String _generateProductId() {
    return 'prod_${DateTime.now().millisecondsSinceEpoch}';
  }
}
