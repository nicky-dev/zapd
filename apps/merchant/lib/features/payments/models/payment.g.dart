// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentImpl _$$PaymentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentImpl(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      method: $enumDecode(_$PaymentMethodEnumMap, json['method']),
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      lightningInvoice: json['lightningInvoice'] as String?,
      paymentHash: json['paymentHash'] as String?,
      preimage: json['preimage'] as String?,
      expiresAt: (json['expiresAt'] as num?)?.toInt(),
      paidAt: (json['paidAt'] as num?)?.toInt(),
      merchantPubkey: json['merchantPubkey'] as String?,
      customerPubkey: json['customerPubkey'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: (json['createdAt'] as num).toInt(),
    );

Map<String, dynamic> _$$PaymentImplToJson(_$PaymentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'amount': instance.amount,
      'currency': instance.currency,
      'method': _$PaymentMethodEnumMap[instance.method]!,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'lightningInvoice': instance.lightningInvoice,
      'paymentHash': instance.paymentHash,
      'preimage': instance.preimage,
      'expiresAt': instance.expiresAt,
      'paidAt': instance.paidAt,
      'merchantPubkey': instance.merchantPubkey,
      'customerPubkey': instance.customerPubkey,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.lightning: 'lightning',
  PaymentMethod.onChain: 'onChain',
  PaymentMethod.other: 'other',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.expired: 'expired',
  PaymentStatus.failed: 'failed',
};

_$LightningInvoiceImpl _$$LightningInvoiceImplFromJson(
  Map<String, dynamic> json,
) => _$LightningInvoiceImpl(
  paymentRequest: json['paymentRequest'] as String,
  paymentHash: json['paymentHash'] as String,
  amount: (json['amount'] as num).toInt(),
  description: json['description'] as String,
  expiresAt: (json['expiresAt'] as num).toInt(),
  createdAt: (json['createdAt'] as num?)?.toInt(),
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$LightningInvoiceImplToJson(
  _$LightningInvoiceImpl instance,
) => <String, dynamic>{
  'paymentRequest': instance.paymentRequest,
  'paymentHash': instance.paymentHash,
  'amount': instance.amount,
  'description': instance.description,
  'expiresAt': instance.expiresAt,
  'createdAt': instance.createdAt,
  'metadata': instance.metadata,
};

_$PaymentRequestImpl _$$PaymentRequestImplFromJson(Map<String, dynamic> json) =>
    _$PaymentRequestImpl(
      orderId: json['orderId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      merchantPubkey: json['merchantPubkey'] as String,
      customerPubkey: json['customerPubkey'] as String,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PaymentRequestImplToJson(
  _$PaymentRequestImpl instance,
) => <String, dynamic>{
  'orderId': instance.orderId,
  'amount': instance.amount,
  'currency': instance.currency,
  'merchantPubkey': instance.merchantPubkey,
  'customerPubkey': instance.customerPubkey,
  'description': instance.description,
  'metadata': instance.metadata,
};
