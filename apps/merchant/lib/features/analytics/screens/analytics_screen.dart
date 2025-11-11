import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/language_switcher.dart';
import '../../../l10n/app_localizations.dart';
import '../models/analytics_data.dart';
import '../providers/analytics_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final period = ref.watch(analyticsPeriodProvider);
    final analytics = ref.watch(salesAnalyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.analytics),
        actions: [
          const LanguageSwitcher(),
          PopupMenuButton<AnalyticsPeriod>(
            initialValue: period,
            onSelected: (value) {
              ref.read(analyticsPeriodProvider.notifier).state = value;
            },
            itemBuilder: (context) => AnalyticsPeriod.values.map((p) {
              return PopupMenuItem(
                value: p,
                child: Text(_getPeriodName(context, p)),
              );
            }).toList(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Reload orders
          ref.invalidate(salesAnalyticsProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period selector
              Text(
                _getPeriodName(context, period),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),

              // Summary cards
              _buildSummaryCards(context, analytics),
              const SizedBox(height: 24),

              // Revenue chart
              _buildRevenueChart(context, analytics),
              const SizedBox(height: 24),

              // Order status distribution
              _buildOrderStatusChart(context, analytics),
              const SizedBox(height: 24),

              // Top products
              _buildTopProducts(context, analytics),
            ],
          ),
        ),
      ),
    );
  }

  String _getPeriodName(BuildContext context, AnalyticsPeriod period) {
    final l10n = AppLocalizations.of(context)!;
    switch (period) {
      case AnalyticsPeriod.today:
        return l10n.periodToday;
      case AnalyticsPeriod.week:
        return l10n.periodWeek;
      case AnalyticsPeriod.month:
        return l10n.periodMonth;
      case AnalyticsPeriod.year:
        return l10n.periodYear;
    }
  }

  Widget _buildSummaryCards(BuildContext context, SalesAnalytics analytics) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
            child: _SummaryCard(
              title: l10n.totalRevenue,
              value: '${l10n.currencySymbol}${analytics.totalRevenue.toStringAsFixed(2)}',
              icon: Icons.attach_money,
              color: Colors.green,
            ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: l10n.totalOrders,
            value: analytics.totalOrders.toString(),
            icon: Icons.shopping_bag,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueChart(BuildContext context, SalesAnalytics analytics) {
    final l10n = AppLocalizations.of(context)!;
    if (analytics.dailySales.isEmpty) {
      return _buildEmptyChart(context, l10n.noDataAvailable);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.revenueTrend,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withAlpha((0.2 * 255).round()),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= analytics.dailySales.length) {
                            return const Text('');
                          }
                          final date = analytics.dailySales[value.toInt()].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              DateFormat('d/M').format(date),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${l10n.currencySymbol}${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(color: Colors.grey.withAlpha((0.2 * 255).round())),
                      bottom: BorderSide(color: Colors.grey.withAlpha((0.2 * 255).round())),
                    ),
                  ),
                  minX: 0,
                  maxX: (analytics.dailySales.length - 1).toDouble(),
                  minY: 0,
                  maxY: _getMaxRevenue(analytics.dailySales) * 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: analytics.dailySales.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.revenue,
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withAlpha((0.1 * 255).round()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusChart(BuildContext context, SalesAnalytics analytics) {
    final l10n = AppLocalizations.of(context)!;
    if (analytics.ordersByStatus.isEmpty) {
      return _buildEmptyChart(context, l10n.noDataAvailable);
    }

    final total = analytics.ordersByStatus.values.reduce((a, b) => a + b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.orderStatusDistribution,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _buildPieSections(analytics.ordersByStatus, total),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  _buildLegend(analytics.ordersByStatus, total, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProducts(BuildContext context, SalesAnalytics analytics) {
    final l10n = AppLocalizations.of(context)!;
    if (analytics.topProducts.isEmpty) {
      return _buildEmptyChart(context, l10n.noDataAvailable);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.topProducts,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...analytics.topProducts.take(5).map((product) {
              final l10n = AppLocalizations.of(context)!;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            l10n.soldCount(product.quantitySold),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '฿${product.revenue.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyChart(BuildContext context, String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.analytics_outlined, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(
    Map<String, int> ordersByStatus,
    int total,
  ) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
    ];

    return ordersByStatus.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final statusEntry = entry.value;
      final percentage = (statusEntry.value / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: statusEntry.value.toDouble(),
        title: '$percentage%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, int> ordersByStatus, int total, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: ordersByStatus.entries.toList().asMap().entries.map((entry) {
        final index = entry.key;
        final statusEntry = entry.value;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${statusEntry.key}: ${statusEntry.value} ${l10n.orders}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  double _getMaxRevenue(List<DailySales> dailySales) {
    if (dailySales.isEmpty) return 0;
    return dailySales.map((d) => d.revenue).reduce((a, b) => a > b ? a : b);
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha((0.1 * 255).round()),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
