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
    final profile = json['assetProfile'] ?? {};
    return CompanyDetail(
      symbol: symbol,
      description:
          profile['longBusinessSummary'] ?? 'No description available.',
      sector: profile['sector'] ?? 'N/A',
      industry: profile['industry'] ?? 'N/A',
      website: profile['website'] ?? 'N/A',
    );
  }
}
