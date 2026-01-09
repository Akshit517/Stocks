class StockSearchResult {
  final String symbol;
  final String name;
  final String exchange;

  StockSearchResult({
    required this.symbol,
    required this.name,
    required this.exchange,
  });

  factory StockSearchResult.fromJson(Map<String, dynamic> json) {
    return StockSearchResult(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      exchange: json['exchDisp'] ?? '',
    );
  }
}
