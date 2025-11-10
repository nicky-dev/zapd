// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      stallId: json['stallId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      currency: json['currency'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num?)?.toInt(),
      specs:
          (json['specs'] as List<dynamic>?)
              ?.map((e) => ProductSpec.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      shipping:
          (json['shipping'] as List<dynamic>?)
              ?.map((e) => ProductShipping.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      spicyLevel: (json['spicyLevel'] as num?)?.toInt(),
      preparationTime: (json['preparationTime'] as num?)?.toInt(),
      dailyLimit: (json['dailyLimit'] as num?)?.toInt(),
      available: json['available'] as bool?,
      eventId: json['eventId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stallId': instance.stallId,
      'name': instance.name,
      'description': instance.description,
      'images': instance.images,
      'currency': instance.currency,
      'price': instance.price,
      'quantity': instance.quantity,
      'specs': instance.specs,
      'shipping': instance.shipping,
      'categories': instance.categories,
      'spicyLevel': instance.spicyLevel,
      'preparationTime': instance.preparationTime,
      'dailyLimit': instance.dailyLimit,
      'available': instance.available,
      'eventId': instance.eventId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$ProductSpecImpl _$$ProductSpecImplFromJson(Map<String, dynamic> json) =>
    _$ProductSpecImpl(
      key: json['key'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$$ProductSpecImplToJson(_$ProductSpecImpl instance) =>
    <String, dynamic>{'key': instance.key, 'value': instance.value};

_$ProductShippingImpl _$$ProductShippingImplFromJson(
  Map<String, dynamic> json,
) => _$ProductShippingImpl(
  id: json['id'] as String,
  cost: (json['cost'] as num).toDouble(),
);

Map<String, dynamic> _$$ProductShippingImplToJson(
  _$ProductShippingImpl instance,
) => <String, dynamic>{'id': instance.id, 'cost': instance.cost};
