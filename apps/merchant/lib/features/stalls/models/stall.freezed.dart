// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stall.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Stall _$StallFromJson(Map<String, dynamic> json) {
  return _Stall.fromJson(json);
}

/// @nodoc
mixin _$Stall {
  // NIP-15 Core Fields
  String get id =>
      throw _privateConstructorUsedError; // d tag - merchant generated ID
  String get name => throw _privateConstructorUsedError; // stall name
  String? get description =>
      throw _privateConstructorUsedError; // stall description (optional per NIP-15)
  String get currency =>
      throw _privateConstructorUsedError; // currency used (BTC, USD, THB, etc.)
  List<ShippingZone> get shipping =>
      throw _privateConstructorUsedError; // NIP-15 shipping zones
  // Food Delivery Extensions (stored as tags or in description)
  StallType? get stallType =>
      throw _privateConstructorUsedError; // food or shop (custom extension)
  String? get cuisine =>
      throw _privateConstructorUsedError; // for food stalls (thai, italian, japanese, etc.)
  bool get acceptsOrders =>
      throw _privateConstructorUsedError; // whether accepting orders
  int? get preparationTime =>
      throw _privateConstructorUsedError; // average preparation time in minutes
  String? get operatingHours =>
      throw _privateConstructorUsedError; // "09:00-22:00"
  String? get locationEncrypted =>
      throw _privateConstructorUsedError; // NIP-44 encrypted address for merchant
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get locationName =>
      throw _privateConstructorUsedError; // Metadata (not in event content, derived from event)
  String? get eventId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Stall to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Stall
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StallCopyWith<Stall> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StallCopyWith<$Res> {
  factory $StallCopyWith(Stall value, $Res Function(Stall) then) =
      _$StallCopyWithImpl<$Res, Stall>;
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    String currency,
    List<ShippingZone> shipping,
    StallType? stallType,
    String? cuisine,
    bool acceptsOrders,
    int? preparationTime,
    String? operatingHours,
    String? locationEncrypted,
    double? latitude,
    double? longitude,
    String? locationName,
    String? eventId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$StallCopyWithImpl<$Res, $Val extends Stall>
    implements $StallCopyWith<$Res> {
  _$StallCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Stall
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? currency = null,
    Object? shipping = null,
    Object? stallType = freezed,
    Object? cuisine = freezed,
    Object? acceptsOrders = null,
    Object? preparationTime = freezed,
    Object? operatingHours = freezed,
    Object? locationEncrypted = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? locationName = freezed,
    Object? eventId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            shipping: null == shipping
                ? _value.shipping
                : shipping // ignore: cast_nullable_to_non_nullable
                      as List<ShippingZone>,
            stallType: freezed == stallType
                ? _value.stallType
                : stallType // ignore: cast_nullable_to_non_nullable
                      as StallType?,
            cuisine: freezed == cuisine
                ? _value.cuisine
                : cuisine // ignore: cast_nullable_to_non_nullable
                      as String?,
            acceptsOrders: null == acceptsOrders
                ? _value.acceptsOrders
                : acceptsOrders // ignore: cast_nullable_to_non_nullable
                      as bool,
            preparationTime: freezed == preparationTime
                ? _value.preparationTime
                : preparationTime // ignore: cast_nullable_to_non_nullable
                      as int?,
            operatingHours: freezed == operatingHours
                ? _value.operatingHours
                : operatingHours // ignore: cast_nullable_to_non_nullable
                      as String?,
            locationEncrypted: freezed == locationEncrypted
                ? _value.locationEncrypted
                : locationEncrypted // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            locationName: freezed == locationName
                ? _value.locationName
                : locationName // ignore: cast_nullable_to_non_nullable
                      as String?,
            eventId: freezed == eventId
                ? _value.eventId
                : eventId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StallImplCopyWith<$Res> implements $StallCopyWith<$Res> {
  factory _$$StallImplCopyWith(
    _$StallImpl value,
    $Res Function(_$StallImpl) then,
  ) = __$$StallImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    String currency,
    List<ShippingZone> shipping,
    StallType? stallType,
    String? cuisine,
    bool acceptsOrders,
    int? preparationTime,
    String? operatingHours,
    String? locationEncrypted,
    double? latitude,
    double? longitude,
    String? locationName,
    String? eventId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$StallImplCopyWithImpl<$Res>
    extends _$StallCopyWithImpl<$Res, _$StallImpl>
    implements _$$StallImplCopyWith<$Res> {
  __$$StallImplCopyWithImpl(
    _$StallImpl _value,
    $Res Function(_$StallImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Stall
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? currency = null,
    Object? shipping = null,
    Object? stallType = freezed,
    Object? cuisine = freezed,
    Object? acceptsOrders = null,
    Object? preparationTime = freezed,
    Object? operatingHours = freezed,
    Object? locationEncrypted = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? locationName = freezed,
    Object? eventId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$StallImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        shipping: null == shipping
            ? _value._shipping
            : shipping // ignore: cast_nullable_to_non_nullable
                  as List<ShippingZone>,
        stallType: freezed == stallType
            ? _value.stallType
            : stallType // ignore: cast_nullable_to_non_nullable
                  as StallType?,
        cuisine: freezed == cuisine
            ? _value.cuisine
            : cuisine // ignore: cast_nullable_to_non_nullable
                  as String?,
        acceptsOrders: null == acceptsOrders
            ? _value.acceptsOrders
            : acceptsOrders // ignore: cast_nullable_to_non_nullable
                  as bool,
        preparationTime: freezed == preparationTime
            ? _value.preparationTime
            : preparationTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        operatingHours: freezed == operatingHours
            ? _value.operatingHours
            : operatingHours // ignore: cast_nullable_to_non_nullable
                  as String?,
        locationEncrypted: freezed == locationEncrypted
            ? _value.locationEncrypted
            : locationEncrypted // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        locationName: freezed == locationName
            ? _value.locationName
            : locationName // ignore: cast_nullable_to_non_nullable
                  as String?,
        eventId: freezed == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StallImpl implements _Stall {
  const _$StallImpl({
    required this.id,
    required this.name,
    this.description,
    required this.currency,
    final List<ShippingZone> shipping = const [],
    this.stallType,
    this.cuisine,
    this.acceptsOrders = true,
    this.preparationTime,
    this.operatingHours,
    this.locationEncrypted,
    this.latitude,
    this.longitude,
    this.locationName,
    this.eventId,
    this.createdAt,
    this.updatedAt,
  }) : _shipping = shipping;

  factory _$StallImpl.fromJson(Map<String, dynamic> json) =>
      _$$StallImplFromJson(json);

  // NIP-15 Core Fields
  @override
  final String id;
  // d tag - merchant generated ID
  @override
  final String name;
  // stall name
  @override
  final String? description;
  // stall description (optional per NIP-15)
  @override
  final String currency;
  // currency used (BTC, USD, THB, etc.)
  final List<ShippingZone> _shipping;
  // currency used (BTC, USD, THB, etc.)
  @override
  @JsonKey()
  List<ShippingZone> get shipping {
    if (_shipping is EqualUnmodifiableListView) return _shipping;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shipping);
  }

  // NIP-15 shipping zones
  // Food Delivery Extensions (stored as tags or in description)
  @override
  final StallType? stallType;
  // food or shop (custom extension)
  @override
  final String? cuisine;
  // for food stalls (thai, italian, japanese, etc.)
  @override
  @JsonKey()
  final bool acceptsOrders;
  // whether accepting orders
  @override
  final int? preparationTime;
  // average preparation time in minutes
  @override
  final String? operatingHours;
  // "09:00-22:00"
  @override
  final String? locationEncrypted;
  // NIP-44 encrypted address for merchant
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? locationName;
  // Metadata (not in event content, derived from event)
  @override
  final String? eventId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Stall(id: $id, name: $name, description: $description, currency: $currency, shipping: $shipping, stallType: $stallType, cuisine: $cuisine, acceptsOrders: $acceptsOrders, preparationTime: $preparationTime, operatingHours: $operatingHours, locationEncrypted: $locationEncrypted, latitude: $latitude, longitude: $longitude, locationName: $locationName, eventId: $eventId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StallImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality().equals(other._shipping, _shipping) &&
            (identical(other.stallType, stallType) ||
                other.stallType == stallType) &&
            (identical(other.cuisine, cuisine) || other.cuisine == cuisine) &&
            (identical(other.acceptsOrders, acceptsOrders) ||
                other.acceptsOrders == acceptsOrders) &&
            (identical(other.preparationTime, preparationTime) ||
                other.preparationTime == preparationTime) &&
            (identical(other.operatingHours, operatingHours) ||
                other.operatingHours == operatingHours) &&
            (identical(other.locationEncrypted, locationEncrypted) ||
                other.locationEncrypted == locationEncrypted) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    currency,
    const DeepCollectionEquality().hash(_shipping),
    stallType,
    cuisine,
    acceptsOrders,
    preparationTime,
    operatingHours,
    locationEncrypted,
    latitude,
    longitude,
    locationName,
    eventId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Stall
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StallImplCopyWith<_$StallImpl> get copyWith =>
      __$$StallImplCopyWithImpl<_$StallImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StallImplToJson(this);
  }
}

abstract class _Stall implements Stall {
  const factory _Stall({
    required final String id,
    required final String name,
    final String? description,
    required final String currency,
    final List<ShippingZone> shipping,
    final StallType? stallType,
    final String? cuisine,
    final bool acceptsOrders,
    final int? preparationTime,
    final String? operatingHours,
    final String? locationEncrypted,
    final double? latitude,
    final double? longitude,
    final String? locationName,
    final String? eventId,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$StallImpl;

  factory _Stall.fromJson(Map<String, dynamic> json) = _$StallImpl.fromJson;

  // NIP-15 Core Fields
  @override
  String get id; // d tag - merchant generated ID
  @override
  String get name; // stall name
  @override
  String? get description; // stall description (optional per NIP-15)
  @override
  String get currency; // currency used (BTC, USD, THB, etc.)
  @override
  List<ShippingZone> get shipping; // NIP-15 shipping zones
  // Food Delivery Extensions (stored as tags or in description)
  @override
  StallType? get stallType; // food or shop (custom extension)
  @override
  String? get cuisine; // for food stalls (thai, italian, japanese, etc.)
  @override
  bool get acceptsOrders; // whether accepting orders
  @override
  int? get preparationTime; // average preparation time in minutes
  @override
  String? get operatingHours; // "09:00-22:00"
  @override
  String? get locationEncrypted; // NIP-44 encrypted address for merchant
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get locationName; // Metadata (not in event content, derived from event)
  @override
  String? get eventId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Stall
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StallImplCopyWith<_$StallImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShippingZone _$ShippingZoneFromJson(Map<String, dynamic> json) {
  return _ShippingZone.fromJson(json);
}

/// @nodoc
mixin _$ShippingZone {
  String get id =>
      throw _privateConstructorUsedError; // zone ID generated by merchant
  String? get name =>
      throw _privateConstructorUsedError; // zone name (optional)
  double get cost =>
      throw _privateConstructorUsedError; // base shipping cost in stall currency
  List<String> get regions => throw _privateConstructorUsedError;

  /// Serializes this ShippingZone to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShippingZone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShippingZoneCopyWith<ShippingZone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShippingZoneCopyWith<$Res> {
  factory $ShippingZoneCopyWith(
    ShippingZone value,
    $Res Function(ShippingZone) then,
  ) = _$ShippingZoneCopyWithImpl<$Res, ShippingZone>;
  @useResult
  $Res call({String id, String? name, double cost, List<String> regions});
}

/// @nodoc
class _$ShippingZoneCopyWithImpl<$Res, $Val extends ShippingZone>
    implements $ShippingZoneCopyWith<$Res> {
  _$ShippingZoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShippingZone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? cost = null,
    Object? regions = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            cost: null == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as double,
            regions: null == regions
                ? _value.regions
                : regions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShippingZoneImplCopyWith<$Res>
    implements $ShippingZoneCopyWith<$Res> {
  factory _$$ShippingZoneImplCopyWith(
    _$ShippingZoneImpl value,
    $Res Function(_$ShippingZoneImpl) then,
  ) = __$$ShippingZoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String? name, double cost, List<String> regions});
}

/// @nodoc
class __$$ShippingZoneImplCopyWithImpl<$Res>
    extends _$ShippingZoneCopyWithImpl<$Res, _$ShippingZoneImpl>
    implements _$$ShippingZoneImplCopyWith<$Res> {
  __$$ShippingZoneImplCopyWithImpl(
    _$ShippingZoneImpl _value,
    $Res Function(_$ShippingZoneImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShippingZone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? cost = null,
    Object? regions = null,
  }) {
    return _then(
      _$ShippingZoneImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        cost: null == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as double,
        regions: null == regions
            ? _value._regions
            : regions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShippingZoneImpl implements _ShippingZone {
  const _$ShippingZoneImpl({
    required this.id,
    this.name,
    required this.cost,
    final List<String> regions = const [],
  }) : _regions = regions;

  factory _$ShippingZoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShippingZoneImplFromJson(json);

  @override
  final String id;
  // zone ID generated by merchant
  @override
  final String? name;
  // zone name (optional)
  @override
  final double cost;
  // base shipping cost in stall currency
  final List<String> _regions;
  // base shipping cost in stall currency
  @override
  @JsonKey()
  List<String> get regions {
    if (_regions is EqualUnmodifiableListView) return _regions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_regions);
  }

  @override
  String toString() {
    return 'ShippingZone(id: $id, name: $name, cost: $cost, regions: $regions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShippingZoneImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            const DeepCollectionEquality().equals(other._regions, _regions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    cost,
    const DeepCollectionEquality().hash(_regions),
  );

  /// Create a copy of ShippingZone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShippingZoneImplCopyWith<_$ShippingZoneImpl> get copyWith =>
      __$$ShippingZoneImplCopyWithImpl<_$ShippingZoneImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShippingZoneImplToJson(this);
  }
}

abstract class _ShippingZone implements ShippingZone {
  const factory _ShippingZone({
    required final String id,
    final String? name,
    required final double cost,
    final List<String> regions,
  }) = _$ShippingZoneImpl;

  factory _ShippingZone.fromJson(Map<String, dynamic> json) =
      _$ShippingZoneImpl.fromJson;

  @override
  String get id; // zone ID generated by merchant
  @override
  String? get name; // zone name (optional)
  @override
  double get cost; // base shipping cost in stall currency
  @override
  List<String> get regions;

  /// Create a copy of ShippingZone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShippingZoneImplCopyWith<_$ShippingZoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
