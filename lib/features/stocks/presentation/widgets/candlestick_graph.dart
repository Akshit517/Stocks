import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../viewmodels/stock_view_model.dart';

class CandlestickGraph extends StatelessWidget {
  final double minY, maxY, xInterval;
  final StockViewModel model;
  final List<CandlestickSpot> spots;
  final Set<String> selectedRange;
  const CandlestickGraph(
    this.minY,
    this.maxY,
    this.xInterval, {
    super.key,
    required this.model,
    required this.spots,
    required this.selectedRange,
  });

  @override
  Widget build(BuildContext context) {
    return CandlestickChart(
      CandlestickChartData(
        candlestickSpots: spots,
        minY: minY,
        maxY: maxY,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 5, // ~5 horizontal grid lines
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withValues(alpha: 0.2),
              strokeWidth: 1,
            );
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

  String _formatDate(DateTime date) {
    final range = selectedRange.first;

    if (range == '1D') {
      return DateFormat('HH:mm').format(date);
    } else if (range == '1W' || range == '1M') {
      return DateFormat('MM/dd').format(date);
    } else if (range == '1Y') {
      return DateFormat('MMM').format(date);
    } else {
      return DateFormat('yyyy').format(date);
    }
  }
}
