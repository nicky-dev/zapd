import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nostr_core/nostr_core.dart';
import '../models/stall.dart';
import '../models/stall_type.dart';

/// Repository for managing Stalls using NIP-15 (kind 30017)
class StallRepository {
  final NostrClient nostrClient;
  final String merchantPubkey;

  StallRepository({
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

  /// Create or update a stall (kind 30017)
  /// Returns the event ID of the published stall
  Future<String> saveStall({
    required Stall stall,
    required String privateKey,
  }) async {
    // NIP-15 required fields in content
    final contentData = <String, dynamic>{
      'id': stall.id,
      'name': stall.name,
      'currency': stall.currency,
    };

    // Add optional description
    if (stall.description != null && stall.description!.isNotEmpty) {
      contentData['description'] = stall.description!;
    }

    // NIP-15 shipping zones array
    contentData['shipping'] = stall.shipping.map((zone) {
      final zoneData = <String, dynamic>{
        'id': zone.id,
        'cost': zone.cost,
        'regions': zone.regions,
      };
      if (zone.name != null) {
        zoneData['name'] = zone.name!;
      }
      return zoneData;
    }).toList();

    final tags = <List<String>>[
      ['d', stall.id], // NIP-15 required: unique identifier
    ];

    // Food delivery extensions
    if (stall.stallType != null) {
      tags.add(['stall_type', stall.stallType!.name]);
    }

    if (stall.cuisine != null && stall.cuisine!.isNotEmpty) {
      tags.add(['cuisine', stall.cuisine!]);
    }

    if (stall.preparationTime != null) {
      tags.add(['preparation_time', stall.preparationTime.toString()]);
    }

    if (stall.operatingHours != null && stall.operatingHours!.isNotEmpty) {
      tags.add(['operating_hours', stall.operatingHours!]);
    }

    if (stall.locationEncrypted != null && stall.locationEncrypted!.isNotEmpty) {
      tags.add(['location_encrypted', stall.locationEncrypted!]);
    }

    tags.add(['accepts_orders', stall.acceptsOrders.toString()]);

    // Build unsigned event
    final unsignedEvent = EventBuilder()
        .pubkey(merchantPubkey)
        .kind(30017) // NIP-15 Stall
        .content(jsonEncode(contentData))
        .addTags(tags)
        .build();

    // Sign and publish
    final signedEvent = _signEvent(unsignedEvent, privateKey);
    await nostrClient.publish(signedEvent);

    return signedEvent.id;
  }

  /// Fetch all stalls for the merchant
  Future<List<Stall>> fetchMyStalls() async {
    final filter = NostrFilter(
      kinds: const [30017],
      authors: [merchantPubkey],
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
    
    // Group events by 'd' tag (stall ID) and keep only the latest one
    final stallMap = <String, NostrEvent>{};
    for (final event in events) {
      // Find 'd' tag
      final dTag = event.tags.firstWhere(
        (tag) => tag.isNotEmpty && tag[0] == 'd',
        orElse: () => [],
      );
      
      if (dTag.length >= 2) {
        final stallId = dTag[1];
        final existing = stallMap[stallId];
        
        // Keep the event with the latest createdAt timestamp
        if (existing == null || event.createdAt > existing.createdAt) {
          stallMap[stallId] = event;
        }
      }
    }
    
    // Convert unique events to Stall objects
    // Filter out deleted stalls (empty content)
    return stallMap.values
        .where((event) => event.content.isNotEmpty) // Skip deleted stalls
        .map(_eventToStall)
        .where((s) => s != null)
        .cast<Stall>()
        .toList();
  }

  /// Fetch a single stall by ID
  Future<Stall?> fetchStallById(String stallId) async {
    final filter = NostrFilter(
      kinds: const [30017],
      authors: [merchantPubkey],
      tags: {'d': [stallId]},
    );

    final subscription = nostrClient.subscribe([filter]);
    Stall? result;

    // Get first matching event
    await for (final event in subscription.stream.timeout(
      const Duration(seconds: 2),
      onTimeout: (sink) => sink.close(),
    )) {
      result = _eventToStall(event);
      if (result != null) break;
    }

    subscription.onClose();
    return result;
  }

  /// Duplicate a stall with a new ID
  Stall duplicateStall(Stall original) {
    final newId = _generateStallId();
    return original.copyWith(
      id: newId,
      name: '${original.name} (Copy)',
      eventId: null, // Will be assigned when saved
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Delete a stall (publish deletion event NIP-09)
  /// Delete a stall by publishing an empty replacement event
  /// NIP-15: For Parameterized Replaceable Events, publish empty content to delete
  Future<void> deleteStall({
    required String stallId,
    required String privateKey,
  }) async {
    // NIP-33: Delete by publishing a replacement event with empty content
    // This is the correct way to delete Parameterized Replaceable Events
    final unsignedEvent = EventBuilder()
        .pubkey(merchantPubkey)
        .kind(30017) // Same kind as stall
        .content('') // Empty content means deleted
        .addTag(['d', stallId]) // Same identifier
        .build();

    final signedEvent = _signEvent(unsignedEvent, privateKey);
  await nostrClient.publish(signedEvent);

  debugPrint('Deleted stall $stallId by publishing empty replacement event');
  }

  /// Convert NostrEvent to Stall model
  Stall? _eventToStall(NostrEvent event) {
    try {
      final content = jsonDecode(event.content) as Map<String, dynamic>;
      
      // Create a map of tags for easy access
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

      // Parse stall type (extension field)
      final stallTypeStr = tagMap['stall_type']?.first;
      StallType? stallType;
      if (stallTypeStr != null) {
        stallType = StallType.values.firstWhere(
          (t) => t.name == stallTypeStr,
          orElse: () => StallType.shop,
        );
      }

      // Parse NIP-15 shipping zones from content
      final shippingList = (content['shipping'] as List<dynamic>?) ?? [];
      final shipping = shippingList.map((s) {
        final shippingData = s as Map<String, dynamic>;
        return ShippingZone(
          id: shippingData['id'] as String,
          name: shippingData['name'] as String?,
          cost: (shippingData['cost'] as num).toDouble(),
          regions: (shippingData['regions'] as List<dynamic>?)?.cast<String>() ?? [],
        );
      }).toList();

      return Stall(
        id: content['id'] as String? ?? tagMap['d']?.first ?? '',
        name: content['name'] as String? ?? '',
        description: content['description'] as String?,
        currency: content['currency'] as String? ?? 'BTC',
        shipping: shipping,
        // Extension fields
        stallType: stallType,
        cuisine: tagMap['cuisine']?.firstOrNull,
        preparationTime: int.tryParse(tagMap['preparation_time']?.first ?? ''),
        operatingHours: tagMap['operating_hours']?.firstOrNull,
        locationEncrypted: tagMap['location_encrypted']?.firstOrNull,
        acceptsOrders: tagMap['accepts_orders']?.first == 'true',
      );
    } catch (e) {
      debugPrint('Error parsing stall event: $e');
      return null;
    }
  }

  /// Generate a unique stall ID
  String _generateStallId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
