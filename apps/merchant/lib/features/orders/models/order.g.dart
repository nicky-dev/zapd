// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: json['id'] as String,
  customerPubkey: json['customerPubkey'] as String,
  merchantPubkey: json['merchantPubkey'] as String,
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  stallId: json['stallId'] as String?,
  stallName: json['stallName'] as String?,
  estimatedReady: json['estimatedReady'] == null
      ? null
      : DateTime.parse(json['estimatedReady'] as String),
  riderPubkey: json['riderPubkey'] as String?,
  statusEventId: json['statusEventId'] as String?,
  detailsEventId: json['detailsEventId'] as String?,
  details: json['details'] == null
      ? null
      : OrderDetails.fromJson(json['details'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerPubkey': instance.customerPubkey,
      'merchantPubkey': instance.merchantPubkey,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'stallId': instance.stallId,
      'stallName': instance.stallName,
      'estimatedReady': instance.estimatedReady?.toIso8601String(),
      'riderPubkey': instance.riderPubkey,
      'statusEventId': instance.statusEventId,
      'detailsEventId': instance.detailsEventId,
      'details': instance.details,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.accepted: 'accepted',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.delivering: 'delivering',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
};

_$OrderDetailsImpl _$$OrderDetailsImplFromJson(Map<String, dynamic> json) =>
    _$OrderDetailsImpl(
      id: json['id'] as String,
      type: (json['type'] as num?)?.toInt() ?? 0,
      name: json['name'] as String?,
      address: json['address'] as String?,
      message: json['message'] as String?,
      contact: ContactInfo.fromJson(json['contact'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingId: json['shippingId'] as String,
      paymentHash: json['paymentHash'] as String?,
      paymentPreimage: json['paymentPreimage'] as String?,
      total: (json['total'] as num?)?.toInt(),
      subtotal: (json['subtotal'] as num?)?.toInt(),
      shippingCost: (json['shippingCost'] as num?)?.toInt(),
      discount: (json['discount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$OrderDetailsImplToJson(_$OrderDetailsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'address': instance.address,
      'message': instance.message,
      'contact': instance.contact,
      'items': instance.items,
      'shippingId': instance.shippingId,
      'paymentHash': instance.paymentHash,
      'paymentPreimage': instance.paymentPreimage,
      'total': instance.total,
      'subtotal': instance.subtotal,
      'shippingCost': instance.shippingCost,
      'discount': instance.discount,
    };

_$ContactInfoImpl _$$ContactInfoImplFromJson(Map<String, dynamic> json) =>
    _$ContactInfoImpl(
      nostr: json['nostr'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$ContactInfoImplToJson(_$ContactInfoImpl instance) =>
    <String, dynamic>{
      'nostr': instance.nostr,
      'phone': instance.phone,
      'email': instance.email,
    };

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      productName: json['productName'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      customization: json['customization'] as Map<String, dynamic>?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
      'productName': instance.productName,
      'price': instance.price,
      'customization': instance.customization,
      'notes': instance.notes,
    };

_$PaymentRequestImpl _$$PaymentRequestImplFromJson(Map<String, dynamic> json) =>
    _$PaymentRequestImpl(
      id: json['id'] as String,
      type: (json['type'] as num?)?.toInt() ?? 1,
      message: json['message'] as String?,
      paymentOptions:
          (json['paymentOptions'] as List<dynamic>?)
              ?.map((e) => PaymentOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PaymentRequestImplToJson(
  _$PaymentRequestImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'message': instance.message,
  'paymentOptions': instance.paymentOptions,
};

_$PaymentOptionImpl _$$PaymentOptionImplFromJson(Map<String, dynamic> json) =>
    _$PaymentOptionImpl(
      type: json['type'] as String,
      link: json['link'] as String,
    );

Map<String, dynamic> _$$PaymentOptionImplToJson(_$PaymentOptionImpl instance) =>
    <String, dynamic>{'type': instance.type, 'link': instance.link};

_$OrderStatusUpdateImpl _$$OrderStatusUpdateImplFromJson(
  Map<String, dynamic> json,
) => _$OrderStatusUpdateImpl(
  id: json['id'] as String,
  type: (json['type'] as num?)?.toInt() ?? 2,
  message: json['message'] as String?,
  paid: json['paid'] as bool,
  shipped: json['shipped'] as bool,
);

Map<String, dynamic> _$$OrderStatusUpdateImplToJson(
  _$OrderStatusUpdateImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'message': instance.message,
  'paid': instance.paid,
  'shipped': instance.shipped,
};

_$DeliveryAddressImpl _$$DeliveryAddressImplFromJson(
  Map<String, dynamic> json,
) => _$DeliveryAddressImpl(
  street: json['street'] as String,
  city: json['city'] as String,
  district: json['district'] as String?,
  postcode: json['postcode'] as String?,
  country: json['country'] as String?,
  lat: (json['lat'] as num?)?.toDouble(),
  lon: (json['lon'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$DeliveryAddressImplToJson(
  _$DeliveryAddressImpl instance,
) => <String, dynamic>{
  'street': instance.street,
  'city': instance.city,
  'district': instance.district,
  'postcode': instance.postcode,
  'country': instance.country,
  'lat': instance.lat,
  'lon': instance.lon,
  'notes': instance.notes,
};
