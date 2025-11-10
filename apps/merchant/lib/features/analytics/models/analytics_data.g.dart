// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalesAnalyticsImpl _$$SalesAnalyticsImplFromJson(Map<String, dynamic> json) =>
    _$SalesAnalyticsImpl(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalOrders: (json['totalOrders'] as num).toInt(),
      averageOrderValue: (json['averageOrderValue'] as num).toDouble(),
      dailySales: (json['dailySales'] as List<dynamic>)
          .map((e) => DailySales.fromJson(e as Map<String, dynamic>))
          .toList(),
      topProducts: (json['topProducts'] as List<dynamic>)
          .map((e) => ProductSales.fromJson(e as Map<String, dynamic>))
          .toList(),
      ordersByStatus: Map<String, int>.from(json['ordersByStatus'] as Map),
    );

Map<String, dynamic> _$$SalesAnalyticsImplToJson(
  _$SalesAnalyticsImpl instance,
) => <String, dynamic>{
  'totalRevenue': instance.totalRevenue,
  'totalOrders': instance.totalOrders,
  'averageOrderValue': instance.averageOrderValue,
  'dailySales': instance.dailySales,
  'topProducts': instance.topProducts,
  'ordersByStatus': instance.ordersByStatus,
};

_$DailySalesImpl _$$DailySalesImplFromJson(Map<String, dynamic> json) =>
    _$DailySalesImpl(
      date: DateTime.parse(json['date'] as String),
      revenue: (json['revenue'] as num).toDouble(),
      orderCount: (json['orderCount'] as num).toInt(),
    );

Map<String, dynamic> _$$DailySalesImplToJson(_$DailySalesImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'revenue': instance.revenue,
      'orderCount': instance.orderCount,
    };

_$ProductSalesImpl _$$ProductSalesImplFromJson(Map<String, dynamic> json) =>
    _$ProductSalesImpl(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantitySold: (json['quantitySold'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$$ProductSalesImplToJson(_$ProductSalesImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'quantitySold': instance.quantitySold,
      'revenue': instance.revenue,
    };
