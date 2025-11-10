// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SalesAnalytics _$SalesAnalyticsFromJson(Map<String, dynamic> json) {
  return _SalesAnalytics.fromJson(json);
}

/// @nodoc
mixin _$SalesAnalytics {
  double get totalRevenue => throw _privateConstructorUsedError;
  int get totalOrders => throw _privateConstructorUsedError;
  double get averageOrderValue => throw _privateConstructorUsedError;
  List<DailySales> get dailySales => throw _privateConstructorUsedError;
  List<ProductSales> get topProducts => throw _privateConstructorUsedError;
  Map<String, int> get ordersByStatus => throw _privateConstructorUsedError;

  /// Serializes this SalesAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalesAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalesAnalyticsCopyWith<SalesAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesAnalyticsCopyWith<$Res> {
  factory $SalesAnalyticsCopyWith(
    SalesAnalytics value,
    $Res Function(SalesAnalytics) then,
  ) = _$SalesAnalyticsCopyWithImpl<$Res, SalesAnalytics>;
  @useResult
  $Res call({
    double totalRevenue,
    int totalOrders,
    double averageOrderValue,
    List<DailySales> dailySales,
    List<ProductSales> topProducts,
    Map<String, int> ordersByStatus,
  });
}

/// @nodoc
class _$SalesAnalyticsCopyWithImpl<$Res, $Val extends SalesAnalytics>
    implements $SalesAnalyticsCopyWith<$Res> {
  _$SalesAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalesAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRevenue = null,
    Object? totalOrders = null,
    Object? averageOrderValue = null,
    Object? dailySales = null,
    Object? topProducts = null,
    Object? ordersByStatus = null,
  }) {
    return _then(
      _value.copyWith(
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            totalOrders: null == totalOrders
                ? _value.totalOrders
                : totalOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            averageOrderValue: null == averageOrderValue
                ? _value.averageOrderValue
                : averageOrderValue // ignore: cast_nullable_to_non_nullable
                      as double,
            dailySales: null == dailySales
                ? _value.dailySales
                : dailySales // ignore: cast_nullable_to_non_nullable
                      as List<DailySales>,
            topProducts: null == topProducts
                ? _value.topProducts
                : topProducts // ignore: cast_nullable_to_non_nullable
                      as List<ProductSales>,
            ordersByStatus: null == ordersByStatus
                ? _value.ordersByStatus
                : ordersByStatus // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalesAnalyticsImplCopyWith<$Res>
    implements $SalesAnalyticsCopyWith<$Res> {
  factory _$$SalesAnalyticsImplCopyWith(
    _$SalesAnalyticsImpl value,
    $Res Function(_$SalesAnalyticsImpl) then,
  ) = __$$SalesAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double totalRevenue,
    int totalOrders,
    double averageOrderValue,
    List<DailySales> dailySales,
    List<ProductSales> topProducts,
    Map<String, int> ordersByStatus,
  });
}

/// @nodoc
class __$$SalesAnalyticsImplCopyWithImpl<$Res>
    extends _$SalesAnalyticsCopyWithImpl<$Res, _$SalesAnalyticsImpl>
    implements _$$SalesAnalyticsImplCopyWith<$Res> {
  __$$SalesAnalyticsImplCopyWithImpl(
    _$SalesAnalyticsImpl _value,
    $Res Function(_$SalesAnalyticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalesAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRevenue = null,
    Object? totalOrders = null,
    Object? averageOrderValue = null,
    Object? dailySales = null,
    Object? topProducts = null,
    Object? ordersByStatus = null,
  }) {
    return _then(
      _$SalesAnalyticsImpl(
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        totalOrders: null == totalOrders
            ? _value.totalOrders
            : totalOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        averageOrderValue: null == averageOrderValue
            ? _value.averageOrderValue
            : averageOrderValue // ignore: cast_nullable_to_non_nullable
                  as double,
        dailySales: null == dailySales
            ? _value._dailySales
            : dailySales // ignore: cast_nullable_to_non_nullable
                  as List<DailySales>,
        topProducts: null == topProducts
            ? _value._topProducts
            : topProducts // ignore: cast_nullable_to_non_nullable
                  as List<ProductSales>,
        ordersByStatus: null == ordersByStatus
            ? _value._ordersByStatus
            : ordersByStatus // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalesAnalyticsImpl implements _SalesAnalytics {
  const _$SalesAnalyticsImpl({
    required this.totalRevenue,
    required this.totalOrders,
    required this.averageOrderValue,
    required final List<DailySales> dailySales,
    required final List<ProductSales> topProducts,
    required final Map<String, int> ordersByStatus,
  }) : _dailySales = dailySales,
       _topProducts = topProducts,
       _ordersByStatus = ordersByStatus;

  factory _$SalesAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesAnalyticsImplFromJson(json);

  @override
  final double totalRevenue;
  @override
  final int totalOrders;
  @override
  final double averageOrderValue;
  final List<DailySales> _dailySales;
  @override
  List<DailySales> get dailySales {
    if (_dailySales is EqualUnmodifiableListView) return _dailySales;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailySales);
  }

  final List<ProductSales> _topProducts;
  @override
  List<ProductSales> get topProducts {
    if (_topProducts is EqualUnmodifiableListView) return _topProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topProducts);
  }

  final Map<String, int> _ordersByStatus;
  @override
  Map<String, int> get ordersByStatus {
    if (_ordersByStatus is EqualUnmodifiableMapView) return _ordersByStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ordersByStatus);
  }

  @override
  String toString() {
    return 'SalesAnalytics(totalRevenue: $totalRevenue, totalOrders: $totalOrders, averageOrderValue: $averageOrderValue, dailySales: $dailySales, topProducts: $topProducts, ordersByStatus: $ordersByStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesAnalyticsImpl &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.averageOrderValue, averageOrderValue) ||
                other.averageOrderValue == averageOrderValue) &&
            const DeepCollectionEquality().equals(
              other._dailySales,
              _dailySales,
            ) &&
            const DeepCollectionEquality().equals(
              other._topProducts,
              _topProducts,
            ) &&
            const DeepCollectionEquality().equals(
              other._ordersByStatus,
              _ordersByStatus,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalRevenue,
    totalOrders,
    averageOrderValue,
    const DeepCollectionEquality().hash(_dailySales),
    const DeepCollectionEquality().hash(_topProducts),
    const DeepCollectionEquality().hash(_ordersByStatus),
  );

  /// Create a copy of SalesAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesAnalyticsImplCopyWith<_$SalesAnalyticsImpl> get copyWith =>
      __$$SalesAnalyticsImplCopyWithImpl<_$SalesAnalyticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesAnalyticsImplToJson(this);
  }
}

abstract class _SalesAnalytics implements SalesAnalytics {
  const factory _SalesAnalytics({
    required final double totalRevenue,
    required final int totalOrders,
    required final double averageOrderValue,
    required final List<DailySales> dailySales,
    required final List<ProductSales> topProducts,
    required final Map<String, int> ordersByStatus,
  }) = _$SalesAnalyticsImpl;

  factory _SalesAnalytics.fromJson(Map<String, dynamic> json) =
      _$SalesAnalyticsImpl.fromJson;

  @override
  double get totalRevenue;
  @override
  int get totalOrders;
  @override
  double get averageOrderValue;
  @override
  List<DailySales> get dailySales;
  @override
  List<ProductSales> get topProducts;
  @override
  Map<String, int> get ordersByStatus;

  /// Create a copy of SalesAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalesAnalyticsImplCopyWith<_$SalesAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailySales _$DailySalesFromJson(Map<String, dynamic> json) {
  return _DailySales.fromJson(json);
}

/// @nodoc
mixin _$DailySales {
  DateTime get date => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;
  int get orderCount => throw _privateConstructorUsedError;

  /// Serializes this DailySales to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailySales
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailySalesCopyWith<DailySales> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailySalesCopyWith<$Res> {
  factory $DailySalesCopyWith(
    DailySales value,
    $Res Function(DailySales) then,
  ) = _$DailySalesCopyWithImpl<$Res, DailySales>;
  @useResult
  $Res call({DateTime date, double revenue, int orderCount});
}

/// @nodoc
class _$DailySalesCopyWithImpl<$Res, $Val extends DailySales>
    implements $DailySalesCopyWith<$Res> {
  _$DailySalesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailySales
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? revenue = null,
    Object? orderCount = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            revenue: null == revenue
                ? _value.revenue
                : revenue // ignore: cast_nullable_to_non_nullable
                      as double,
            orderCount: null == orderCount
                ? _value.orderCount
                : orderCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailySalesImplCopyWith<$Res>
    implements $DailySalesCopyWith<$Res> {
  factory _$$DailySalesImplCopyWith(
    _$DailySalesImpl value,
    $Res Function(_$DailySalesImpl) then,
  ) = __$$DailySalesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, double revenue, int orderCount});
}

/// @nodoc
class __$$DailySalesImplCopyWithImpl<$Res>
    extends _$DailySalesCopyWithImpl<$Res, _$DailySalesImpl>
    implements _$$DailySalesImplCopyWith<$Res> {
  __$$DailySalesImplCopyWithImpl(
    _$DailySalesImpl _value,
    $Res Function(_$DailySalesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailySales
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? revenue = null,
    Object? orderCount = null,
  }) {
    return _then(
      _$DailySalesImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        revenue: null == revenue
            ? _value.revenue
            : revenue // ignore: cast_nullable_to_non_nullable
                  as double,
        orderCount: null == orderCount
            ? _value.orderCount
            : orderCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailySalesImpl implements _DailySales {
  const _$DailySalesImpl({
    required this.date,
    required this.revenue,
    required this.orderCount,
  });

  factory _$DailySalesImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailySalesImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double revenue;
  @override
  final int orderCount;

  @override
  String toString() {
    return 'DailySales(date: $date, revenue: $revenue, orderCount: $orderCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailySalesImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, revenue, orderCount);

  /// Create a copy of DailySales
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailySalesImplCopyWith<_$DailySalesImpl> get copyWith =>
      __$$DailySalesImplCopyWithImpl<_$DailySalesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailySalesImplToJson(this);
  }
}

abstract class _DailySales implements DailySales {
  const factory _DailySales({
    required final DateTime date,
    required final double revenue,
    required final int orderCount,
  }) = _$DailySalesImpl;

  factory _DailySales.fromJson(Map<String, dynamic> json) =
      _$DailySalesImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get revenue;
  @override
  int get orderCount;

  /// Create a copy of DailySales
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailySalesImplCopyWith<_$DailySalesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductSales _$ProductSalesFromJson(Map<String, dynamic> json) {
  return _ProductSales.fromJson(json);
}

/// @nodoc
mixin _$ProductSales {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get quantitySold => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;

  /// Serializes this ProductSales to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductSales
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductSalesCopyWith<ProductSales> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductSalesCopyWith<$Res> {
  factory $ProductSalesCopyWith(
    ProductSales value,
    $Res Function(ProductSales) then,
  ) = _$ProductSalesCopyWithImpl<$Res, ProductSales>;
  @useResult
  $Res call({
    String productId,
    String productName,
    int quantitySold,
    double revenue,
  });
}

/// @nodoc
class _$ProductSalesCopyWithImpl<$Res, $Val extends ProductSales>
    implements $ProductSalesCopyWith<$Res> {
  _$ProductSalesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductSales
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? quantitySold = null,
    Object? revenue = null,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            quantitySold: null == quantitySold
                ? _value.quantitySold
                : quantitySold // ignore: cast_nullable_to_non_nullable
                      as int,
            revenue: null == revenue
                ? _value.revenue
                : revenue // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductSalesImplCopyWith<$Res>
    implements $ProductSalesCopyWith<$Res> {
  factory _$$ProductSalesImplCopyWith(
    _$ProductSalesImpl value,
    $Res Function(_$ProductSalesImpl) then,
  ) = __$$ProductSalesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String productId,
    String productName,
    int quantitySold,
    double revenue,
  });
}

/// @nodoc
class __$$ProductSalesImplCopyWithImpl<$Res>
    extends _$ProductSalesCopyWithImpl<$Res, _$ProductSalesImpl>
    implements _$$ProductSalesImplCopyWith<$Res> {
  __$$ProductSalesImplCopyWithImpl(
    _$ProductSalesImpl _value,
    $Res Function(_$ProductSalesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductSales
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? quantitySold = null,
    Object? revenue = null,
  }) {
    return _then(
      _$ProductSalesImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        quantitySold: null == quantitySold
            ? _value.quantitySold
            : quantitySold // ignore: cast_nullable_to_non_nullable
                  as int,
        revenue: null == revenue
            ? _value.revenue
            : revenue // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductSalesImpl implements _ProductSales {
  const _$ProductSalesImpl({
    required this.productId,
    required this.productName,
    required this.quantitySold,
    required this.revenue,
  });

  factory _$ProductSalesImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductSalesImplFromJson(json);

  @override
  final String productId;
  @override
  final String productName;
  @override
  final int quantitySold;
  @override
  final double revenue;

  @override
  String toString() {
    return 'ProductSales(productId: $productId, productName: $productName, quantitySold: $quantitySold, revenue: $revenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductSalesImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.quantitySold, quantitySold) ||
                other.quantitySold == quantitySold) &&
            (identical(other.revenue, revenue) || other.revenue == revenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, productId, productName, quantitySold, revenue);

  /// Create a copy of ProductSales
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductSalesImplCopyWith<_$ProductSalesImpl> get copyWith =>
      __$$ProductSalesImplCopyWithImpl<_$ProductSalesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductSalesImplToJson(this);
  }
}

abstract class _ProductSales implements ProductSales {
  const factory _ProductSales({
    required final String productId,
    required final String productName,
    required final int quantitySold,
    required final double revenue,
  }) = _$ProductSalesImpl;

  factory _ProductSales.fromJson(Map<String, dynamic> json) =
      _$ProductSalesImpl.fromJson;

  @override
  String get productId;
  @override
  String get productName;
  @override
  int get quantitySold;
  @override
  double get revenue;

  /// Create a copy of ProductSales
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductSalesImplCopyWith<_$ProductSalesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
