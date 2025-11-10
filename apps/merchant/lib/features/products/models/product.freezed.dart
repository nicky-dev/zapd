// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  // NIP-15 Core Fields
  String get id =>
      throw _privateConstructorUsedError; // d tag - merchant generated ID
  String get stallId =>
      throw _privateConstructorUsedError; // stall_id reference
  String get name => throw _privateConstructorUsedError; // product name
  String? get description =>
      throw _privateConstructorUsedError; // product description (optional per NIP-15)
  List<String> get images =>
      throw _privateConstructorUsedError; // array of image URLs (optional)
  String get currency =>
      throw _privateConstructorUsedError; // currency used (must match stall currency typically)
  double get price =>
      throw _privateConstructorUsedError; // cost of product (using double for NIP-15 float)
  int? get quantity =>
      throw _privateConstructorUsedError; // available items (null = unlimited like digital items)
  List<ProductSpec> get specs =>
      throw _privateConstructorUsedError; // array of [key, value] specifications
  List<ProductShipping> get shipping =>
      throw _privateConstructorUsedError; // extra shipping costs per zone
  // Food Delivery Extensions (can be stored in specs or as tags)
  List<String> get categories =>
      throw _privateConstructorUsedError; // t tags: food, fruits, main-dish, etc.
  int? get spicyLevel =>
      throw _privateConstructorUsedError; // 0-5 for food (stored in specs)
  int? get preparationTime =>
      throw _privateConstructorUsedError; // item-specific prep time in minutes (stored in specs)
  int? get dailyLimit =>
      throw _privateConstructorUsedError; // max units per day (stored in specs)
  bool? get available =>
      throw _privateConstructorUsedError; // current availability toggle (stored in specs or tags)
  // Metadata (not in event content, derived from event)
  String? get eventId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call({
    String id,
    String stallId,
    String name,
    String? description,
    List<String> images,
    String currency,
    double price,
    int? quantity,
    List<ProductSpec> specs,
    List<ProductShipping> shipping,
    List<String> categories,
    int? spicyLevel,
    int? preparationTime,
    int? dailyLimit,
    bool? available,
    String? eventId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stallId = null,
    Object? name = null,
    Object? description = freezed,
    Object? images = null,
    Object? currency = null,
    Object? price = null,
    Object? quantity = freezed,
    Object? specs = null,
    Object? shipping = null,
    Object? categories = null,
    Object? spicyLevel = freezed,
    Object? preparationTime = freezed,
    Object? dailyLimit = freezed,
    Object? available = freezed,
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
            stallId: null == stallId
                ? _value.stallId
                : stallId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            quantity: freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int?,
            specs: null == specs
                ? _value.specs
                : specs // ignore: cast_nullable_to_non_nullable
                      as List<ProductSpec>,
            shipping: null == shipping
                ? _value.shipping
                : shipping // ignore: cast_nullable_to_non_nullable
                      as List<ProductShipping>,
            categories: null == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            spicyLevel: freezed == spicyLevel
                ? _value.spicyLevel
                : spicyLevel // ignore: cast_nullable_to_non_nullable
                      as int?,
            preparationTime: freezed == preparationTime
                ? _value.preparationTime
                : preparationTime // ignore: cast_nullable_to_non_nullable
                      as int?,
            dailyLimit: freezed == dailyLimit
                ? _value.dailyLimit
                : dailyLimit // ignore: cast_nullable_to_non_nullable
                      as int?,
            available: freezed == available
                ? _value.available
                : available // ignore: cast_nullable_to_non_nullable
                      as bool?,
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
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
    _$ProductImpl value,
    $Res Function(_$ProductImpl) then,
  ) = __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String stallId,
    String name,
    String? description,
    List<String> images,
    String currency,
    double price,
    int? quantity,
    List<ProductSpec> specs,
    List<ProductShipping> shipping,
    List<String> categories,
    int? spicyLevel,
    int? preparationTime,
    int? dailyLimit,
    bool? available,
    String? eventId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
    _$ProductImpl _value,
    $Res Function(_$ProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stallId = null,
    Object? name = null,
    Object? description = freezed,
    Object? images = null,
    Object? currency = null,
    Object? price = null,
    Object? quantity = freezed,
    Object? specs = null,
    Object? shipping = null,
    Object? categories = null,
    Object? spicyLevel = freezed,
    Object? preparationTime = freezed,
    Object? dailyLimit = freezed,
    Object? available = freezed,
    Object? eventId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ProductImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        stallId: null == stallId
            ? _value.stallId
            : stallId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        quantity: freezed == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int?,
        specs: null == specs
            ? _value._specs
            : specs // ignore: cast_nullable_to_non_nullable
                  as List<ProductSpec>,
        shipping: null == shipping
            ? _value._shipping
            : shipping // ignore: cast_nullable_to_non_nullable
                  as List<ProductShipping>,
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        spicyLevel: freezed == spicyLevel
            ? _value.spicyLevel
            : spicyLevel // ignore: cast_nullable_to_non_nullable
                  as int?,
        preparationTime: freezed == preparationTime
            ? _value.preparationTime
            : preparationTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        dailyLimit: freezed == dailyLimit
            ? _value.dailyLimit
            : dailyLimit // ignore: cast_nullable_to_non_nullable
                  as int?,
        available: freezed == available
            ? _value.available
            : available // ignore: cast_nullable_to_non_nullable
                  as bool?,
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
class _$ProductImpl implements _Product {
  const _$ProductImpl({
    required this.id,
    required this.stallId,
    required this.name,
    this.description,
    final List<String> images = const [],
    required this.currency,
    required this.price,
    this.quantity,
    final List<ProductSpec> specs = const [],
    final List<ProductShipping> shipping = const [],
    final List<String> categories = const [],
    this.spicyLevel,
    this.preparationTime,
    this.dailyLimit,
    this.available,
    this.eventId,
    this.createdAt,
    this.updatedAt,
  }) : _images = images,
       _specs = specs,
       _shipping = shipping,
       _categories = categories;

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  // NIP-15 Core Fields
  @override
  final String id;
  // d tag - merchant generated ID
  @override
  final String stallId;
  // stall_id reference
  @override
  final String name;
  // product name
  @override
  final String? description;
  // product description (optional per NIP-15)
  final List<String> _images;
  // product description (optional per NIP-15)
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  // array of image URLs (optional)
  @override
  final String currency;
  // currency used (must match stall currency typically)
  @override
  final double price;
  // cost of product (using double for NIP-15 float)
  @override
  final int? quantity;
  // available items (null = unlimited like digital items)
  final List<ProductSpec> _specs;
  // available items (null = unlimited like digital items)
  @override
  @JsonKey()
  List<ProductSpec> get specs {
    if (_specs is EqualUnmodifiableListView) return _specs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specs);
  }

  // array of [key, value] specifications
  final List<ProductShipping> _shipping;
  // array of [key, value] specifications
  @override
  @JsonKey()
  List<ProductShipping> get shipping {
    if (_shipping is EqualUnmodifiableListView) return _shipping;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shipping);
  }

  // extra shipping costs per zone
  // Food Delivery Extensions (can be stored in specs or as tags)
  final List<String> _categories;
  // extra shipping costs per zone
  // Food Delivery Extensions (can be stored in specs or as tags)
  @override
  @JsonKey()
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  // t tags: food, fruits, main-dish, etc.
  @override
  final int? spicyLevel;
  // 0-5 for food (stored in specs)
  @override
  final int? preparationTime;
  // item-specific prep time in minutes (stored in specs)
  @override
  final int? dailyLimit;
  // max units per day (stored in specs)
  @override
  final bool? available;
  // current availability toggle (stored in specs or tags)
  // Metadata (not in event content, derived from event)
  @override
  final String? eventId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Product(id: $id, stallId: $stallId, name: $name, description: $description, images: $images, currency: $currency, price: $price, quantity: $quantity, specs: $specs, shipping: $shipping, categories: $categories, spicyLevel: $spicyLevel, preparationTime: $preparationTime, dailyLimit: $dailyLimit, available: $available, eventId: $eventId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.stallId, stallId) || other.stallId == stallId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            const DeepCollectionEquality().equals(other._specs, _specs) &&
            const DeepCollectionEquality().equals(other._shipping, _shipping) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            (identical(other.spicyLevel, spicyLevel) ||
                other.spicyLevel == spicyLevel) &&
            (identical(other.preparationTime, preparationTime) ||
                other.preparationTime == preparationTime) &&
            (identical(other.dailyLimit, dailyLimit) ||
                other.dailyLimit == dailyLimit) &&
            (identical(other.available, available) ||
                other.available == available) &&
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
    stallId,
    name,
    description,
    const DeepCollectionEquality().hash(_images),
    currency,
    price,
    quantity,
    const DeepCollectionEquality().hash(_specs),
    const DeepCollectionEquality().hash(_shipping),
    const DeepCollectionEquality().hash(_categories),
    spicyLevel,
    preparationTime,
    dailyLimit,
    available,
    eventId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(this);
  }
}

abstract class _Product implements Product {
  const factory _Product({
    required final String id,
    required final String stallId,
    required final String name,
    final String? description,
    final List<String> images,
    required final String currency,
    required final double price,
    final int? quantity,
    final List<ProductSpec> specs,
    final List<ProductShipping> shipping,
    final List<String> categories,
    final int? spicyLevel,
    final int? preparationTime,
    final int? dailyLimit,
    final bool? available,
    final String? eventId,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  // NIP-15 Core Fields
  @override
  String get id; // d tag - merchant generated ID
  @override
  String get stallId; // stall_id reference
  @override
  String get name; // product name
  @override
  String? get description; // product description (optional per NIP-15)
  @override
  List<String> get images; // array of image URLs (optional)
  @override
  String get currency; // currency used (must match stall currency typically)
  @override
  double get price; // cost of product (using double for NIP-15 float)
  @override
  int? get quantity; // available items (null = unlimited like digital items)
  @override
  List<ProductSpec> get specs; // array of [key, value] specifications
  @override
  List<ProductShipping> get shipping; // extra shipping costs per zone
  // Food Delivery Extensions (can be stored in specs or as tags)
  @override
  List<String> get categories; // t tags: food, fruits, main-dish, etc.
  @override
  int? get spicyLevel; // 0-5 for food (stored in specs)
  @override
  int? get preparationTime; // item-specific prep time in minutes (stored in specs)
  @override
  int? get dailyLimit; // max units per day (stored in specs)
  @override
  bool? get available; // current availability toggle (stored in specs or tags)
  // Metadata (not in event content, derived from event)
  @override
  String? get eventId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductSpec _$ProductSpecFromJson(Map<String, dynamic> json) {
  return _ProductSpec.fromJson(json);
}

/// @nodoc
mixin _$ProductSpec {
  String get key => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  /// Serializes this ProductSpec to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductSpec
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductSpecCopyWith<ProductSpec> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductSpecCopyWith<$Res> {
  factory $ProductSpecCopyWith(
    ProductSpec value,
    $Res Function(ProductSpec) then,
  ) = _$ProductSpecCopyWithImpl<$Res, ProductSpec>;
  @useResult
  $Res call({String key, String value});
}

/// @nodoc
class _$ProductSpecCopyWithImpl<$Res, $Val extends ProductSpec>
    implements $ProductSpecCopyWith<$Res> {
  _$ProductSpecCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductSpec
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? key = null, Object? value = null}) {
    return _then(
      _value.copyWith(
            key: null == key
                ? _value.key
                : key // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductSpecImplCopyWith<$Res>
    implements $ProductSpecCopyWith<$Res> {
  factory _$$ProductSpecImplCopyWith(
    _$ProductSpecImpl value,
    $Res Function(_$ProductSpecImpl) then,
  ) = __$$ProductSpecImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String key, String value});
}

/// @nodoc
class __$$ProductSpecImplCopyWithImpl<$Res>
    extends _$ProductSpecCopyWithImpl<$Res, _$ProductSpecImpl>
    implements _$$ProductSpecImplCopyWith<$Res> {
  __$$ProductSpecImplCopyWithImpl(
    _$ProductSpecImpl _value,
    $Res Function(_$ProductSpecImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductSpec
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? key = null, Object? value = null}) {
    return _then(
      _$ProductSpecImpl(
        key: null == key
            ? _value.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductSpecImpl implements _ProductSpec {
  const _$ProductSpecImpl({required this.key, required this.value});

  factory _$ProductSpecImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductSpecImplFromJson(json);

  @override
  final String key;
  @override
  final String value;

  @override
  String toString() {
    return 'ProductSpec(key: $key, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductSpecImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, value);

  /// Create a copy of ProductSpec
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductSpecImplCopyWith<_$ProductSpecImpl> get copyWith =>
      __$$ProductSpecImplCopyWithImpl<_$ProductSpecImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductSpecImplToJson(this);
  }
}

abstract class _ProductSpec implements ProductSpec {
  const factory _ProductSpec({
    required final String key,
    required final String value,
  }) = _$ProductSpecImpl;

  factory _ProductSpec.fromJson(Map<String, dynamic> json) =
      _$ProductSpecImpl.fromJson;

  @override
  String get key;
  @override
  String get value;

  /// Create a copy of ProductSpec
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductSpecImplCopyWith<_$ProductSpecImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductShipping _$ProductShippingFromJson(Map<String, dynamic> json) {
  return _ProductShipping.fromJson(json);
}

/// @nodoc
mixin _$ProductShipping {
  String get id =>
      throw _privateConstructorUsedError; // must match a shipping zone ID from the stall
  double get cost => throw _privateConstructorUsedError;

  /// Serializes this ProductShipping to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductShipping
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductShippingCopyWith<ProductShipping> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductShippingCopyWith<$Res> {
  factory $ProductShippingCopyWith(
    ProductShipping value,
    $Res Function(ProductShipping) then,
  ) = _$ProductShippingCopyWithImpl<$Res, ProductShipping>;
  @useResult
  $Res call({String id, double cost});
}

/// @nodoc
class _$ProductShippingCopyWithImpl<$Res, $Val extends ProductShipping>
    implements $ProductShippingCopyWith<$Res> {
  _$ProductShippingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductShipping
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? cost = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            cost: null == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductShippingImplCopyWith<$Res>
    implements $ProductShippingCopyWith<$Res> {
  factory _$$ProductShippingImplCopyWith(
    _$ProductShippingImpl value,
    $Res Function(_$ProductShippingImpl) then,
  ) = __$$ProductShippingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, double cost});
}

/// @nodoc
class __$$ProductShippingImplCopyWithImpl<$Res>
    extends _$ProductShippingCopyWithImpl<$Res, _$ProductShippingImpl>
    implements _$$ProductShippingImplCopyWith<$Res> {
  __$$ProductShippingImplCopyWithImpl(
    _$ProductShippingImpl _value,
    $Res Function(_$ProductShippingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductShipping
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? cost = null}) {
    return _then(
      _$ProductShippingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        cost: null == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductShippingImpl implements _ProductShipping {
  const _$ProductShippingImpl({required this.id, required this.cost});

  factory _$ProductShippingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductShippingImplFromJson(json);

  @override
  final String id;
  // must match a shipping zone ID from the stall
  @override
  final double cost;

  @override
  String toString() {
    return 'ProductShipping(id: $id, cost: $cost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductShippingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cost, cost) || other.cost == cost));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, cost);

  /// Create a copy of ProductShipping
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductShippingImplCopyWith<_$ProductShippingImpl> get copyWith =>
      __$$ProductShippingImplCopyWithImpl<_$ProductShippingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductShippingImplToJson(this);
  }
}

abstract class _ProductShipping implements ProductShipping {
  const factory _ProductShipping({
    required final String id,
    required final double cost,
  }) = _$ProductShippingImpl;

  factory _ProductShipping.fromJson(Map<String, dynamic> json) =
      _$ProductShippingImpl.fromJson;

  @override
  String get id; // must match a shipping zone ID from the stall
  @override
  double get cost;

  /// Create a copy of ProductShipping
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductShippingImplCopyWith<_$ProductShippingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
