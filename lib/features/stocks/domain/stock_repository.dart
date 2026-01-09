import 'package:fpdart/fpdart.dart';

import '../../../core/core.dart';
import '../data/models/company_detail.dart';
import '../data/models/stock_history_point.dart';
import '../data/models/stock_search_result.dart';

abstract class StockRepository {
  Future<Either<Failure, List<StockSearchResult>>> searchStocks(String query);
  Future<Either<Failure, List<StockHistoryPoint>>> getStockHistory(
    String symbol,
    String interval,
  );
  Future<Either<Failure, CompanyDetail>> getCompanyDetail(String symbol);
}
