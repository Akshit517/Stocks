import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../../core/core.dart';
import '../viewmodels/stock_view_model.dart';
import '../widgets/candlestick_graph.dart';
import '../widgets/custom_segmented_button.dart';

class StocksDetailView extends StatefulWidget {
  final String symbol;
  const StocksDetailView({super.key, required this.symbol});

  @override
  State<StocksDetailView> createState() => _StocksDetailViewState();
}

class _StocksDetailViewState extends State<StocksDetailView> {
  Set<String> _selectedRange = {'1D'};
  final Map<String, String> rangeIntervals = {
    '1D': '5m',
    '1W': '1h',
    '1M': '1d',
    '1Y': '1wk',
    '5Y': '1mo',
  };

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
                      CustomSegmentedButton(
                        selected: _selectedRange,
                        rangeIntervals: rangeIntervals,
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() => _selectedRange = newSelection);
                          final interval = rangeIntervals[newSelection.first]!;
                          model.updateChartRange(widget.symbol, interval);
                        },
                      ),
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
      height: 350,
      width: double.infinity,
      child: model.stockHistory.isEmpty
          ? const Center(child: Text("No data available for this range"))
          : Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 16.0),
              child: model.isChartLoading
                  ? const Center(child: CircularProgressIndicator())
                  : model.stockHistory.isEmpty
                  ? const Center(
                      child: Text("No data available for this range"),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                      child: _buildCandleChart(model),
                    ),
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

    return CandlestickGraph(
      minY,
      maxY,
      xInterval,
      model: model,
      spots: spots,
      selectedRange: _selectedRange,
    );
  }
}
