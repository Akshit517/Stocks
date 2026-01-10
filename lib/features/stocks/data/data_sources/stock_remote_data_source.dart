import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import '../../../../core/core.dart';
import '../models/company_detail.dart';
import '../models/stock_history_point.dart';
import '../models/stock_search_result.dart';

abstract class StockRemoteDataSource {
  Future<Either<Failure, List<StockSearchResult>>> searchStocks(String query);

  Future<Either<Failure, List<StockHistoryPoint>>> getStockHistory(
    String symbol,
    String interval,
  );

  Future<Either<Failure, CompanyDetail>> getCompanyDetail(String symbol);
}

class StockRemoteDataSourceImpl implements StockRemoteDataSource {
  final http.Client client;
  final String apiKey = dotenv.env['RAPID_API_KEY'] ?? '';
  final String baseUrl = "yahoo-finance15.p.rapidapi.com";

  Map<String, String> get _headers => {
    "x-rapidapi-key": apiKey,
    "x-rapidapi-host": baseUrl,
  };

  StockRemoteDataSourceImpl({required this.client});

  @override
  Future<Either<Failure, List<StockSearchResult>>> searchStocks(
    String query,
  ) async {
    try {
      final url = Uri.parse(
        "https://$baseUrl/api/v1/markets/search?search=$query",
      );

      final response = await client.get(url, headers: _headers);
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List body = data['body'] ?? [];
        return Right(
          body.map((item) => StockSearchResult.fromJson(item)).toList(),
        );
      } else {
        print("FCUK THID ERORR : SEARCH");
        return Left(ServerFailure());
      }
    } catch (e) {
      print("FCUK THID ERORR : SEARCH");
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<StockHistoryPoint>>> getStockHistory(
    String symbol,
    String interval,
  ) async {
    try {
      final url = Uri.https(baseUrl, "/api/v2/markets/stock/history", {
        "symbol": symbol,
        "interval": interval,
        "limit": "100",
      });

      final response = await client.get(url, headers: _headers);
      print(response.body);
      if (response.statusCode == 200) {
        print("it fucking worked (HISTORY)");
        final Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> items = data['body'] ?? [];

        final history = items.map((entry) {
          return StockHistoryPoint.fromJson(entry as Map<String, dynamic>);
        }).toList();

        history.sort((a, b) => a.date.compareTo(b.date));
        return Right(history);
      } else {
        return Left(ServerFailure());
      }
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, CompanyDetail>> getCompanyDetail(String symbol) async {
    try {
      final url = Uri.https(baseUrl, "/api/v1/markets/stock/modules", {
        "ticker": symbol,
        "module": "asset-profile",
      });

      final response = await client.get(url, headers: _headers);
      print(response.body);
      if (response.statusCode == 200) {
        print("it fucking worked (MODULES)");
        final Map<String, dynamic> data = json.decode(response.body);

        final moduleData = data['body'] ?? data;

        return Right(CompanyDetail.fromJson(symbol, moduleData));
      } else {
        return Left(ServerFailure());
      }
    } catch (e) {
      return Left(NetworkFailure());
    }
  }
}
