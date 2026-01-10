import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../viewmodels/stock_view_model.dart';

class StocksDetailView extends StatefulWidget {
  final String title;
  const StocksDetailView({super.key, required this.title});

  @override
  State<StocksDetailView> createState() => _StocksDetailViewState();
}

class _StocksDetailViewState extends State<StocksDetailView> {
  Set<String> _selectedRange = {'1D'};
  @override
  Widget build(BuildContext context) {
    return BaseView<StockViewModel>(
      onModelReady: (model) {
        model.addListener(() {
          if (model.failure != null && mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(model.failure!.message)));
            model.clearFailure();
          }
        });
      },
      builder: (context, model, child) {
        final detail = model.selectedStockDetail!;
        return ResponsiveScaffold(
          title: widget.title,
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      detail.symbol,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => model.clearSelection(),
                    ),
                  ],
                ),
                Text(
                  "${detail.sector} • ${detail.industry}",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // --- TIME RANGE TOGGLES ---
                _buildTimeToggles(model, detail.symbol),

                const SizedBox(height: 16),

                // --- CHART AREA ---
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: model.stockHistory.isEmpty
                      ? const Center(
                          child: Text("No data available for this range"),
                        )
                      : _buildHistoryChart(model),
                ),

                const SizedBox(height: 24),
                const Text(
                  "About",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(detail.description, textAlign: TextAlign.justify),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeToggles(StockViewModel model, String symbol) {
    // Map Display Name -> API Interval
    final Map<String, String> rangeIntervals = {
      '1D': '5m',
      '1W': '1h',
      '1M': '1d',
      '1Y': '1wk',
      '5Y': '1mo',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SegmentedButton<String>(
        segments: rangeIntervals.keys.map((label) {
          return ButtonSegment<String>(
            value: label,
            label: Text(label, style: const TextStyle(fontSize: 12)),
          );
        }).toList(),
        selected: _selectedRange,
        showSelectedIcon: false, // Cleaner look for financial apps
        onSelectionChanged: (Set<String> newSelection) {
          setState(() => _selectedRange = newSelection);

          final selectedLabel = newSelection.first;
          final interval = rangeIntervals[selectedLabel]!;

          model.updateChartRange(symbol, interval);
        },
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: Theme.of(
            context,
          ).colorScheme.primaryContainer,
          selectedForegroundColor: Theme.of(
            context,
          ).colorScheme.onPrimaryContainer,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  Widget _buildHistoryChart(StockViewModel model) {
    if (model.stockHistory.isEmpty) return const SizedBox();

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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: CandlestickChart(
          CandlestickChartData(
            candlestickSpots: spots,
            // Customize appearance
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: const FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
