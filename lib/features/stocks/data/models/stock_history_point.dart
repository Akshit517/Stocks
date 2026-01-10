class StockHistoryPoint {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;

  StockHistoryPoint({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory StockHistoryPoint.fromJson(Map<String, dynamic> json) {
    int timestamp = json['timestamp_unix'];
    return StockHistoryPoint(
      date: DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      volume: (json['volume'] as num).toInt(),
    );
  }
}
