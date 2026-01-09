import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/stock_repository.dart';
import '../data_sources/stock_remote_data_source.dart';
import '../models/company_detail.dart';
import '../models/stock_history_point.dart';
import '../models/stock_search_result.dart';

class StockRepositoryImpl implements StockRepository {
  final StockRemoteDataSource remoteDataSource;

  StockRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<StockSearchResult>>> searchStocks(
    String query,
  ) async {
    return await remoteDataSource.searchStocks(query);
  }

  @override
  Future<Either<Failure, List<StockHistoryPoint>>> getStockHistory(
    String symbol,
    String interval,
  ) async {
    return await remoteDataSource.getStockHistory(symbol, interval);
  }

  @override
  Future<Either<Failure, CompanyDetail>> getCompanyDetail(String symbol) async {
    return await remoteDataSource.getCompanyDetail(symbol);
  }
}
