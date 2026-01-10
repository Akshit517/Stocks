import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../../../../core/core.dart';
import '../viewmodels/stock_view_model.dart';

class StocksDetailView extends StatefulWidget {
  final String symbol;
  const StocksDetailView({super.key, required this.symbol});

  @override
  State<StocksDetailView> createState() => _StocksDetailViewState();
}

class _StocksDetailViewState extends State<StocksDetailView> {
  Set<String> _selectedRange = {'1D'};

  @override
  Widget build(BuildContext context) {
    return BaseView<StockViewModel>(
      onModelReady: (model) {
        model.getStockDetails(symbol: widget.symbol, interval: '1d');
      },
      builder: (context, model, child) {
        return ResponsiveScaffold(
          title: widget.symbol,
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: model.isBusy
                ? const Center(child: CircularProgressIndicator())
                : model.selectedStockDetail == null
                ? const Center(child: Text("Could not load stock data."))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(model),
                      const SizedBox(height: 24),
                      _buildTimeToggles(model, widget.symbol),
                      const SizedBox(height: 16),
                      _buildChartContainer(model),
                      const SizedBox(height: 24),
                      const Text(
                        "About",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        model.selectedStockDetail!.description,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(StockViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.selectedStockDetail!.symbol,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          "${model.selectedStockDetail!.sector} • ${model.selectedStockDetail!.industry}",
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildChartContainer(StockViewModel model) {
    return SizedBox(
      height: 350, // Increased slightly for labels
      width: double.infinity,
      child: model.stockHistory.isEmpty
          ? const Center(child: Text("No data available for this range"))
          : Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
                top: 16.0,
              ), // Padding for Y-axis labels
              child: _buildCandleChart(model),
            ),
    );
  }

  Widget _buildCandleChart(StockViewModel model) {
    final List<CandlestickSpot> spots = model.stockHistory.asMap().entries.map((
      e,
    ) {
      final index = e.key.toDouble();
      final data = e.value;
      return CandlestickSpot(
        x: index,
        open: data.open,
        high: data.high,
        low: data.low,
        close: data.close,
      );
    }).toList();

    // Calculate Min/Max for Y-Axis Scaling
    // This prevents the candles from looking flat
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (var spot in spots) {
      minY = math.min(minY, spot.low);
      maxY = math.max(maxY, spot.high);
    }
    // Add 2% padding to top and bottom
    final double padding = (maxY - minY) * 0.02;
    minY = (minY - padding);
    maxY = (maxY + padding);

    // Determine Label Intervals
    // We want roughly 5 labels on the X axis to avoid overcrowding
    final double xInterval = (spots.length / 5).ceilToDouble();

    return CandlestickChart(
      CandlestickChartData(
        candlestickSpots: spots,
        minY: minY,
        maxY: maxY,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false, // Cleaner look for financial charts
          horizontalInterval: (maxY - minY) / 5, // ~5 horizontal grid lines
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          // RIGHT TITLES: Price Labels
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: (maxY - minY) / 5,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    value.toStringAsFixed(2),
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  ),
                );
              },
            ),
          ),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: xInterval,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= model.stockHistory.length) {
                  return const SizedBox();
                }

                // Get the actual date object from your history data
                // Assuming model.stockHistory has a DateTime property named 'date' or 'timestamp'
                // You might need to adjust 'point.date' based on your StockHistoryPoint model
                final date = model.stockHistory[index].date;

                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    _formatDate(date),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Helper to format dates based on selected range
  String _formatDate(DateTime date) {
    final range = _selectedRange.first;

    if (range == '1D') {
      return DateFormat('HH:mm').format(date); // 14:30
    } else if (range == '1W' || range == '1M') {
      return DateFormat('MM/dd').format(date); // 12/25
    } else if (range == '1Y') {
      return DateFormat('MMM').format(date); // Dec
    } else {
      return DateFormat('yyyy').format(date); // 2023
    }
  }

  Widget _buildTimeToggles(StockViewModel model, String symbol) {
    final Map<String, String> rangeIntervals = {
      '1D': '5m',
      '1W': '1h',
      '1M': '1d',
      '1Y': '1wk',
      '5Y': '1mo',
    };

    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<String>(
        showSelectedIcon: false,
        segments: rangeIntervals.keys.map((label) {
          return ButtonSegment<String>(value: label, label: Text(label));
        }).toList(),
        selected: _selectedRange,
        onSelectionChanged: (Set<String> newSelection) {
          setState(() => _selectedRange = newSelection);
          final interval = rangeIntervals[newSelection.first]!;
          model.updateChartRange(symbol, interval);
        },
      ),
    );
  }
}
