import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analytics_data.dart';
import '../services/analytics_service.dart';
import '../../orders/providers/order_provider.dart';

/// Analytics provider
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

/// Current analytics period
final analyticsPeriodProvider = StateProvider<AnalyticsPeriod>((ref) {
  return AnalyticsPeriod.month;
});

/// Sales analytics provider
final salesAnalyticsProvider = Provider<SalesAnalytics>((ref) {
  final service = ref.watch(analyticsServiceProvider);
  final period = ref.watch(analyticsPeriodProvider);
  final orders = ref.watch(orderNotifierProvider);

  return service.calculateSalesAnalytics(orders, period);
});
