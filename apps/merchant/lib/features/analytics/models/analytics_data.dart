import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_data.freezed.dart';
part 'analytics_data.g.dart';

/// Sales analytics data
@freezed
class SalesAnalytics with _$SalesAnalytics {
  const factory SalesAnalytics({
    required double totalRevenue,
    required int totalOrders,
    required double averageOrderValue,
    required List<DailySales> dailySales,
    required List<ProductSales> topProducts,
    required Map<String, int> ordersByStatus,
  }) = _SalesAnalytics;

  factory SalesAnalytics.fromJson(Map<String, dynamic> json) =>
      _$SalesAnalyticsFromJson(json);
}

/// Daily sales data point
@freezed
class DailySales with _$DailySales {
  const factory DailySales({
    required DateTime date,
    required double revenue,
    required int orderCount,
  }) = _DailySales;

  factory DailySales.fromJson(Map<String, dynamic> json) =>
      _$DailySalesFromJson(json);
}

/// Product sales data
@freezed
class ProductSales with _$ProductSales {
  const factory ProductSales({
    required String productId,
    required String productName,
    required int quantitySold,
    required double revenue,
  }) = _ProductSales;

  factory ProductSales.fromJson(Map<String, dynamic> json) =>
      _$ProductSalesFromJson(json);
}

/// Time period for analytics
enum AnalyticsPeriod {
  today,
  week,
  month,
  year,
}

extension AnalyticsPeriodExtension on AnalyticsPeriod {
  String get displayName {
    switch (this) {
      case AnalyticsPeriod.today:
        return 'Today';
      case AnalyticsPeriod.week:
        return 'This Week';
      case AnalyticsPeriod.month:
        return 'This Month';
      case AnalyticsPeriod.year:
        return 'This Year';
    }
  }

  DateTime get startDate {
    final now = DateTime.now();
    switch (this) {
      case AnalyticsPeriod.today:
        return DateTime(now.year, now.month, now.day);
      case AnalyticsPeriod.week:
        return now.subtract(Duration(days: now.weekday - 1));
      case AnalyticsPeriod.month:
        return DateTime(now.year, now.month, 1);
      case AnalyticsPeriod.year:
        return DateTime(now.year, 1, 1);
    }
  }
}
