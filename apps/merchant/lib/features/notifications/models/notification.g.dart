// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationImpl _$$AppNotificationImplFromJson(
  Map<String, dynamic> json,
) => _$AppNotificationImpl(
  id: json['id'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  title: json['title'] as String,
  message: json['message'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  isRead: json['isRead'] as bool? ?? false,
  orderId: json['orderId'] as String?,
  paymentId: json['paymentId'] as String?,
  stallId: json['stallId'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$AppNotificationImplToJson(
  _$AppNotificationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'title': instance.title,
  'message': instance.message,
  'timestamp': instance.timestamp.toIso8601String(),
  'isRead': instance.isRead,
  'orderId': instance.orderId,
  'paymentId': instance.paymentId,
  'stallId': instance.stallId,
  'metadata': instance.metadata,
};

const _$NotificationTypeEnumMap = {
  NotificationType.newOrder: 'newOrder',
  NotificationType.orderUpdate: 'orderUpdate',
  NotificationType.payment: 'payment',
  NotificationType.system: 'system',
};
