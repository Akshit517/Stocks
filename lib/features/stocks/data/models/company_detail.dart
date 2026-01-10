class CompanyDetail {
  final String symbol;
  final String description;
  final String sector;
  final String industry;
  final String website;

  CompanyDetail({
    required this.symbol,
    required this.description,
    required this.sector,
    required this.industry,
    required this.website,
  });

  factory CompanyDetail.fromJson(String symbol, Map<String, dynamic> json) {
    return CompanyDetail(
      symbol: symbol,
      description: json['longBusinessSummary'] ?? 'No description available.',
      sector: json['sector'] ?? 'N/A',
      industry: json['industry'] ?? 'N/A',
      website: json['website'] ?? 'N/A',
    );
  }
}
