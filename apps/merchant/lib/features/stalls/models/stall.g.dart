// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stall.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StallImpl _$$StallImplFromJson(Map<String, dynamic> json) => _$StallImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  currency: json['currency'] as String,
  shipping:
      (json['shipping'] as List<dynamic>?)
          ?.map((e) => ShippingZone.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  stallType: $enumDecodeNullable(_$StallTypeEnumMap, json['stallType']),
  cuisine: json['cuisine'] as String?,
  acceptsOrders: json['acceptsOrders'] as bool? ?? true,
  preparationTime: (json['preparationTime'] as num?)?.toInt(),
  operatingHours: json['operatingHours'] as String?,
  locationEncrypted: json['locationEncrypted'] as String?,
  eventId: json['eventId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$StallImplToJson(_$StallImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'currency': instance.currency,
      'shipping': instance.shipping,
      'stallType': _$StallTypeEnumMap[instance.stallType],
      'cuisine': instance.cuisine,
      'acceptsOrders': instance.acceptsOrders,
      'preparationTime': instance.preparationTime,
      'operatingHours': instance.operatingHours,
      'locationEncrypted': instance.locationEncrypted,
      'eventId': instance.eventId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$StallTypeEnumMap = {StallType.food: 'food', StallType.shop: 'shop'};

_$ShippingZoneImpl _$$ShippingZoneImplFromJson(Map<String, dynamic> json) =>
    _$ShippingZoneImpl(
      id: json['id'] as String,
      name: json['name'] as String?,
      cost: (json['cost'] as num).toDouble(),
      regions:
          (json['regions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ShippingZoneImplToJson(_$ShippingZoneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cost': instance.cost,
      'regions': instance.regions,
    };
