// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return _Payment.fromJson(json);
}

/// @nodoc
mixin _$Payment {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  PaymentMethod get method => throw _privateConstructorUsedError;
  PaymentStatus get status => throw _privateConstructorUsedError;
  String? get lightningInvoice => throw _privateConstructorUsedError;
  String? get paymentHash => throw _privateConstructorUsedError;
  String? get preimage => throw _privateConstructorUsedError;
  int? get expiresAt => throw _privateConstructorUsedError;
  int? get paidAt => throw _privateConstructorUsedError;
  String? get merchantPubkey => throw _privateConstructorUsedError;
  String? get customerPubkey => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  int get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentCopyWith<Payment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentCopyWith<$Res> {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) then) =
      _$PaymentCopyWithImpl<$Res, Payment>;
  @useResult
  $Res call({
    String id,
    String orderId,
    double amount,
    String currency,
    PaymentMethod method,
    PaymentStatus status,
    String? lightningInvoice,
    String? paymentHash,
    String? preimage,
    int? expiresAt,
    int? paidAt,
    String? merchantPubkey,
    String? customerPubkey,
    Map<String, dynamic>? metadata,
    int createdAt,
  });
}

/// @nodoc
class _$PaymentCopyWithImpl<$Res, $Val extends Payment>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? amount = null,
    Object? currency = null,
    Object? method = null,
    Object? status = null,
    Object? lightningInvoice = freezed,
    Object? paymentHash = freezed,
    Object? preimage = freezed,
    Object? expiresAt = freezed,
    Object? paidAt = freezed,
    Object? merchantPubkey = freezed,
    Object? customerPubkey = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            method: null == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as PaymentMethod,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PaymentStatus,
            lightningInvoice: freezed == lightningInvoice
                ? _value.lightningInvoice
                : lightningInvoice // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentHash: freezed == paymentHash
                ? _value.paymentHash
                : paymentHash // ignore: cast_nullable_to_non_nullable
                      as String?,
            preimage: freezed == preimage
                ? _value.preimage
                : preimage // ignore: cast_nullable_to_non_nullable
                      as String?,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as int?,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as int?,
            merchantPubkey: freezed == merchantPubkey
                ? _value.merchantPubkey
                : merchantPubkey // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerPubkey: freezed == customerPubkey
                ? _value.customerPubkey
                : customerPubkey // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentImplCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$$PaymentImplCopyWith(
    _$PaymentImpl value,
    $Res Function(_$PaymentImpl) then,
  ) = __$$PaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderId,
    double amount,
    String currency,
    PaymentMethod method,
    PaymentStatus status,
    String? lightningInvoice,
    String? paymentHash,
    String? preimage,
    int? expiresAt,
    int? paidAt,
    String? merchantPubkey,
    String? customerPubkey,
    Map<String, dynamic>? metadata,
    int createdAt,
  });
}

/// @nodoc
class __$$PaymentImplCopyWithImpl<$Res>
    extends _$PaymentCopyWithImpl<$Res, _$PaymentImpl>
    implements _$$PaymentImplCopyWith<$Res> {
  __$$PaymentImplCopyWithImpl(
    _$PaymentImpl _value,
    $Res Function(_$PaymentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? amount = null,
    Object? currency = null,
    Object? method = null,
    Object? status = null,
    Object? lightningInvoice = freezed,
    Object? paymentHash = freezed,
    Object? preimage = freezed,
    Object? expiresAt = freezed,
    Object? paidAt = freezed,
    Object? merchantPubkey = freezed,
    Object? customerPubkey = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$PaymentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        method: null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as PaymentMethod,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PaymentStatus,
        lightningInvoice: freezed == lightningInvoice
            ? _value.lightningInvoice
            : lightningInvoice // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentHash: freezed == paymentHash
            ? _value.paymentHash
            : paymentHash // ignore: cast_nullable_to_non_nullable
                  as String?,
        preimage: freezed == preimage
            ? _value.preimage
            : preimage // ignore: cast_nullable_to_non_nullable
                  as String?,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as int?,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as int?,
        merchantPubkey: freezed == merchantPubkey
            ? _value.merchantPubkey
            : merchantPubkey // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerPubkey: freezed == customerPubkey
            ? _value.customerPubkey
            : customerPubkey // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentImpl implements _Payment {
  const _$PaymentImpl({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    this.lightningInvoice,
    this.paymentHash,
    this.preimage,
    this.expiresAt,
    this.paidAt,
    this.merchantPubkey,
    this.customerPubkey,
    final Map<String, dynamic>? metadata,
    required this.createdAt,
  }) : _metadata = metadata;

  factory _$PaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentImplFromJson(json);

  @override
  final String id;
  @override
  final String orderId;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final PaymentMethod method;
  @override
  final PaymentStatus status;
  @override
  final String? lightningInvoice;
  @override
  final String? paymentHash;
  @override
  final String? preimage;
  @override
  final int? expiresAt;
  @override
  final int? paidAt;
  @override
  final String? merchantPubkey;
  @override
  final String? customerPubkey;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final int createdAt;

  @override
  String toString() {
    return 'Payment(id: $id, orderId: $orderId, amount: $amount, currency: $currency, method: $method, status: $status, lightningInvoice: $lightningInvoice, paymentHash: $paymentHash, preimage: $preimage, expiresAt: $expiresAt, paidAt: $paidAt, merchantPubkey: $merchantPubkey, customerPubkey: $customerPubkey, metadata: $metadata, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.lightningInvoice, lightningInvoice) ||
                other.lightningInvoice == lightningInvoice) &&
            (identical(other.paymentHash, paymentHash) ||
                other.paymentHash == paymentHash) &&
            (identical(other.preimage, preimage) ||
                other.preimage == preimage) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.merchantPubkey, merchantPubkey) ||
                other.merchantPubkey == merchantPubkey) &&
            (identical(other.customerPubkey, customerPubkey) ||
                other.customerPubkey == customerPubkey) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderId,
    amount,
    currency,
    method,
    status,
    lightningInvoice,
    paymentHash,
    preimage,
    expiresAt,
    paidAt,
    merchantPubkey,
    customerPubkey,
    const DeepCollectionEquality().hash(_metadata),
    createdAt,
  );

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      __$$PaymentImplCopyWithImpl<_$PaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentImplToJson(this);
  }
}

abstract class _Payment implements Payment {
  const factory _Payment({
    required final String id,
    required final String orderId,
    required final double amount,
    required final String currency,
    required final PaymentMethod method,
    required final PaymentStatus status,
    final String? lightningInvoice,
    final String? paymentHash,
    final String? preimage,
    final int? expiresAt,
    final int? paidAt,
    final String? merchantPubkey,
    final String? customerPubkey,
    final Map<String, dynamic>? metadata,
    required final int createdAt,
  }) = _$PaymentImpl;

  factory _Payment.fromJson(Map<String, dynamic> json) = _$PaymentImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId;
  @override
  double get amount;
  @override
  String get currency;
  @override
  PaymentMethod get method;
  @override
  PaymentStatus get status;
  @override
  String? get lightningInvoice;
  @override
  String? get paymentHash;
  @override
  String? get preimage;
  @override
  int? get expiresAt;
  @override
  int? get paidAt;
  @override
  String? get merchantPubkey;
  @override
  String? get customerPubkey;
  @override
  Map<String, dynamic>? get metadata;
  @override
  int get createdAt;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LightningInvoice _$LightningInvoiceFromJson(Map<String, dynamic> json) {
  return _LightningInvoice.fromJson(json);
}

/// @nodoc
mixin _$LightningInvoice {
  String get paymentRequest =>
      throw _privateConstructorUsedError; // bolt11 invoice
  String get paymentHash => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError; // in satoshis
  String get description => throw _privateConstructorUsedError;
  int get expiresAt => throw _privateConstructorUsedError;
  int? get createdAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this LightningInvoice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LightningInvoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LightningInvoiceCopyWith<LightningInvoice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LightningInvoiceCopyWith<$Res> {
  factory $LightningInvoiceCopyWith(
    LightningInvoice value,
    $Res Function(LightningInvoice) then,
  ) = _$LightningInvoiceCopyWithImpl<$Res, LightningInvoice>;
  @useResult
  $Res call({
    String paymentRequest,
    String paymentHash,
    int amount,
    String description,
    int expiresAt,
    int? createdAt,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$LightningInvoiceCopyWithImpl<$Res, $Val extends LightningInvoice>
    implements $LightningInvoiceCopyWith<$Res> {
  _$LightningInvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LightningInvoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentRequest = null,
    Object? paymentHash = null,
    Object? amount = null,
    Object? description = null,
    Object? expiresAt = null,
    Object? createdAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            paymentRequest: null == paymentRequest
                ? _value.paymentRequest
                : paymentRequest // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentHash: null == paymentHash
                ? _value.paymentHash
                : paymentHash // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as int?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LightningInvoiceImplCopyWith<$Res>
    implements $LightningInvoiceCopyWith<$Res> {
  factory _$$LightningInvoiceImplCopyWith(
    _$LightningInvoiceImpl value,
    $Res Function(_$LightningInvoiceImpl) then,
  ) = __$$LightningInvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String paymentRequest,
    String paymentHash,
    int amount,
    String description,
    int expiresAt,
    int? createdAt,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$LightningInvoiceImplCopyWithImpl<$Res>
    extends _$LightningInvoiceCopyWithImpl<$Res, _$LightningInvoiceImpl>
    implements _$$LightningInvoiceImplCopyWith<$Res> {
  __$$LightningInvoiceImplCopyWithImpl(
    _$LightningInvoiceImpl _value,
    $Res Function(_$LightningInvoiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LightningInvoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentRequest = null,
    Object? paymentHash = null,
    Object? amount = null,
    Object? description = null,
    Object? expiresAt = null,
    Object? createdAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$LightningInvoiceImpl(
        paymentRequest: null == paymentRequest
            ? _value.paymentRequest
            : paymentRequest // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentHash: null == paymentHash
            ? _value.paymentHash
            : paymentHash // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as int?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LightningInvoiceImpl implements _LightningInvoice {
  const _$LightningInvoiceImpl({
    required this.paymentRequest,
    required this.paymentHash,
    required this.amount,
    required this.description,
    required this.expiresAt,
    this.createdAt,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata;

  factory _$LightningInvoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$LightningInvoiceImplFromJson(json);

  @override
  final String paymentRequest;
  // bolt11 invoice
  @override
  final String paymentHash;
  @override
  final int amount;
  // in satoshis
  @override
  final String description;
  @override
  final int expiresAt;
  @override
  final int? createdAt;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'LightningInvoice(paymentRequest: $paymentRequest, paymentHash: $paymentHash, amount: $amount, description: $description, expiresAt: $expiresAt, createdAt: $createdAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LightningInvoiceImpl &&
            (identical(other.paymentRequest, paymentRequest) ||
                other.paymentRequest == paymentRequest) &&
            (identical(other.paymentHash, paymentHash) ||
                other.paymentHash == paymentHash) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    paymentRequest,
    paymentHash,
    amount,
    description,
    expiresAt,
    createdAt,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of LightningInvoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LightningInvoiceImplCopyWith<_$LightningInvoiceImpl> get copyWith =>
      __$$LightningInvoiceImplCopyWithImpl<_$LightningInvoiceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LightningInvoiceImplToJson(this);
  }
}

abstract class _LightningInvoice implements LightningInvoice {
  const factory _LightningInvoice({
    required final String paymentRequest,
    required final String paymentHash,
    required final int amount,
    required final String description,
    required final int expiresAt,
    final int? createdAt,
    final Map<String, dynamic>? metadata,
  }) = _$LightningInvoiceImpl;

  factory _LightningInvoice.fromJson(Map<String, dynamic> json) =
      _$LightningInvoiceImpl.fromJson;

  @override
  String get paymentRequest; // bolt11 invoice
  @override
  String get paymentHash;
  @override
  int get amount; // in satoshis
  @override
  String get description;
  @override
  int get expiresAt;
  @override
  int? get createdAt;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of LightningInvoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LightningInvoiceImplCopyWith<_$LightningInvoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) {
  return _PaymentRequest.fromJson(json);
}

/// @nodoc
mixin _$PaymentRequest {
  String get orderId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get merchantPubkey => throw _privateConstructorUsedError;
  String get customerPubkey => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this PaymentRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentRequestCopyWith<PaymentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentRequestCopyWith<$Res> {
  factory $PaymentRequestCopyWith(
    PaymentRequest value,
    $Res Function(PaymentRequest) then,
  ) = _$PaymentRequestCopyWithImpl<$Res, PaymentRequest>;
  @useResult
  $Res call({
    String orderId,
    double amount,
    String currency,
    String merchantPubkey,
    String customerPubkey,
    String? description,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$PaymentRequestCopyWithImpl<$Res, $Val extends PaymentRequest>
    implements $PaymentRequestCopyWith<$Res> {
  _$PaymentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? amount = null,
    Object? currency = null,
    Object? merchantPubkey = null,
    Object? customerPubkey = null,
    Object? description = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            merchantPubkey: null == merchantPubkey
                ? _value.merchantPubkey
                : merchantPubkey // ignore: cast_nullable_to_non_nullable
                      as String,
            customerPubkey: null == customerPubkey
                ? _value.customerPubkey
                : customerPubkey // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentRequestImplCopyWith<$Res>
    implements $PaymentRequestCopyWith<$Res> {
  factory _$$PaymentRequestImplCopyWith(
    _$PaymentRequestImpl value,
    $Res Function(_$PaymentRequestImpl) then,
  ) = __$$PaymentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String orderId,
    double amount,
    String currency,
    String merchantPubkey,
    String customerPubkey,
    String? description,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$PaymentRequestImplCopyWithImpl<$Res>
    extends _$PaymentRequestCopyWithImpl<$Res, _$PaymentRequestImpl>
    implements _$$PaymentRequestImplCopyWith<$Res> {
  __$$PaymentRequestImplCopyWithImpl(
    _$PaymentRequestImpl _value,
    $Res Function(_$PaymentRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? amount = null,
    Object? currency = null,
    Object? merchantPubkey = null,
    Object? customerPubkey = null,
    Object? description = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$PaymentRequestImpl(
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        merchantPubkey: null == merchantPubkey
            ? _value.merchantPubkey
            : merchantPubkey // ignore: cast_nullable_to_non_nullable
                  as String,
        customerPubkey: null == customerPubkey
            ? _value.customerPubkey
            : customerPubkey // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentRequestImpl implements _PaymentRequest {
  const _$PaymentRequestImpl({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.merchantPubkey,
    required this.customerPubkey,
    this.description,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata;

  factory _$PaymentRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentRequestImplFromJson(json);

  @override
  final String orderId;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final String merchantPubkey;
  @override
  final String customerPubkey;
  @override
  final String? description;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PaymentRequest(orderId: $orderId, amount: $amount, currency: $currency, merchantPubkey: $merchantPubkey, customerPubkey: $customerPubkey, description: $description, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentRequestImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.merchantPubkey, merchantPubkey) ||
                other.merchantPubkey == merchantPubkey) &&
            (identical(other.customerPubkey, customerPubkey) ||
                other.customerPubkey == customerPubkey) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    orderId,
    amount,
    currency,
    merchantPubkey,
    customerPubkey,
    description,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of PaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentRequestImplCopyWith<_$PaymentRequestImpl> get copyWith =>
      __$$PaymentRequestImplCopyWithImpl<_$PaymentRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentRequestImplToJson(this);
  }
}

abstract class _PaymentRequest implements PaymentRequest {
  const factory _PaymentRequest({
    required final String orderId,
    required final double amount,
    required final String currency,
    required final String merchantPubkey,
    required final String customerPubkey,
    final String? description,
    final Map<String, dynamic>? metadata,
  }) = _$PaymentRequestImpl;

  factory _PaymentRequest.fromJson(Map<String, dynamic> json) =
      _$PaymentRequestImpl.fromJson;

  @override
  String get orderId;
  @override
  double get amount;
  @override
  String get currency;
  @override
  String get merchantPubkey;
  @override
  String get customerPubkey;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of PaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentRequestImplCopyWith<_$PaymentRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
