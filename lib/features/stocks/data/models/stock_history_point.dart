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

  factory StockHistoryPoint.fromJson(
    String timestamp,
    Map<String, dynamic> json,
  ) {
    return StockHistoryPoint(
      // Yahoo uses seconds, Flutter needs milliseconds (* 1000)
      date: DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000),
      // Using .toDouble() ensures we don't get type errors if the API sends an Int
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      volume: (json['volume'] as num).toInt(),
    );
  }
}
