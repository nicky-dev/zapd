import '../models/analytics_data.dart';
import '../../orders/models/order.dart';

/// Analytics service for calculating sales metrics
class AnalyticsService {
  /// Calculate sales analytics for a given period
  SalesAnalytics calculateSalesAnalytics(
    List<Order> orders,
    AnalyticsPeriod period,
  ) {
    final startDate = period.startDate;
    final filteredOrders = orders.where((order) {
      return order.createdAt.isAfter(startDate);
    }).toList();

    // Calculate total revenue and order count
    double totalRevenue = 0;
    int totalOrders = filteredOrders.length;
    
    for (final order in filteredOrders) {
      final total = order.details?.total?.toDouble() ?? 0;
      totalRevenue += total / 100; // Convert from satang to THB
    }

    // Calculate average order value
    final averageOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0.0;

    // Calculate daily sales
    final dailySales = _calculateDailySales(filteredOrders);

    // Calculate top products
    final topProducts = _calculateTopProducts(filteredOrders);

    // Calculate orders by status
    final ordersByStatus = _calculateOrdersByStatus(filteredOrders);

    return SalesAnalytics(
      totalRevenue: totalRevenue,
      totalOrders: totalOrders,
      averageOrderValue: averageOrderValue,
      dailySales: dailySales,
      topProducts: topProducts,
      ordersByStatus: ordersByStatus,
    );
  }

  /// Calculate daily sales breakdown
  List<DailySales> _calculateDailySales(List<Order> orders) {
    final Map<DateTime, DailySalesData> dailyMap = {};

    for (final order in orders) {
      final date = DateTime(
        order.createdAt.year,
        order.createdAt.month,
        order.createdAt.day,
      );

      final total = order.details?.total?.toDouble() ?? 0;
      final revenue = total / 100; // Convert from satang to THB

      if (dailyMap.containsKey(date)) {
        dailyMap[date] = DailySalesData(
          revenue: dailyMap[date]!.revenue + revenue,
          orderCount: dailyMap[date]!.orderCount + 1,
        );
      } else {
        dailyMap[date] = DailySalesData(
          revenue: revenue,
          orderCount: 1,
        );
      }
    }

    final dailySales = dailyMap.entries.map((entry) {
      return DailySales(
        date: entry.key,
        revenue: entry.value.revenue,
        orderCount: entry.value.orderCount,
      );
    }).toList();

    // Sort by date
    dailySales.sort((a, b) => a.date.compareTo(b.date));

    return dailySales;
  }

  /// Calculate top selling products
  List<ProductSales> _calculateTopProducts(List<Order> orders) {
    final Map<String, ProductSalesData> productMap = {};

    for (final order in orders) {
      if (order.details == null) continue;

      for (final item in order.details!.items) {
        final productId = item.productId;
        final productName = item.productName ?? 'Unknown';
        final quantity = item.quantity;
        final price = item.price ?? 0;
        final revenue = price * quantity;

        if (productMap.containsKey(productId)) {
          productMap[productId] = ProductSalesData(
            productName: productName,
            quantitySold: productMap[productId]!.quantitySold + quantity,
            revenue: productMap[productId]!.revenue + revenue,
          );
        } else {
          productMap[productId] = ProductSalesData(
            productName: productName,
            quantitySold: quantity,
            revenue: revenue,
          );
        }
      }
    }

    final productSales = productMap.entries.map((entry) {
      return ProductSales(
        productId: entry.key,
        productName: entry.value.productName,
        quantitySold: entry.value.quantitySold,
        revenue: entry.value.revenue,
      );
    }).toList();

    // Sort by revenue (descending)
    productSales.sort((a, b) => b.revenue.compareTo(a.revenue));

    // Return top 10
    return productSales.take(10).toList();
  }

  /// Calculate order counts by status
  Map<String, int> _calculateOrdersByStatus(List<Order> orders) {
    final Map<String, int> statusMap = {};

    for (final order in orders) {
      final status = order.status.displayName;
      statusMap[status] = (statusMap[status] ?? 0) + 1;
    }

    return statusMap;
  }
}

/// Helper class for daily sales calculation
class DailySalesData {
  final double revenue;
  final int orderCount;

  DailySalesData({
    required this.revenue,
    required this.orderCount,
  });
}

/// Helper class for product sales calculation
class ProductSalesData {
  final String productName;
  final int quantitySold;
  final double revenue;

  ProductSalesData({
    required this.productName,
    required this.quantitySold,
    required this.revenue,
  });
}
