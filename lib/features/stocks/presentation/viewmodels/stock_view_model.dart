import '../../../../core/core.dart';
import '../../data/models/company_detail.dart';
import '../../data/models/stock_history_point.dart';
import '../../data/models/stock_search_result.dart';
import '../../domain/stock_repository.dart';

class StockViewModel extends BaseViewModel {
  final StockRepository _stockRepository;

  StockViewModel(this._stockRepository);

  List<StockSearchResult> _searchResults = [];
  List<StockHistoryPoint> _stockHistory = [];
  CompanyDetail? _selectedStockDetail;
  Failure? _failure;

  List<StockSearchResult> get searchResults => _searchResults;
  List<StockHistoryPoint> get stockHistory => _stockHistory;
  CompanyDetail? get selectedStockDetail => _selectedStockDetail;
  Failure? get failure => _failure;

  Future<void> searchStocks(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    setLoading();
    _failure = null;

    final result = await _stockRepository.searchStocks(query);

    result.fold(
      (failure) => _failure = failure,
      (results) => _searchResults = results,
    );

    setIdle();
  }

  Future<void> getStockDetails({
    required String symbol,
    required String interval,
  }) async {
    setLoading();
    _failure = null;

    final detailResult = await _stockRepository.getCompanyDetail(symbol);
    final historyResult = await _stockRepository.getStockHistory(
      symbol,
      interval,
    );

    detailResult.fold(
      (failure) => _failure = failure,
      (detail) => _selectedStockDetail = detail,
    );

    historyResult.fold(
      (failure) => _failure = failure,
      (history) => _stockHistory = history,
    );

    setIdle();
  }

  Future<void> updateChartRange(String symbol, String interval) async {
    setLoading();

    final result = await _stockRepository.getStockHistory(symbol, interval);

    result.fold(
      (failure) => _failure = failure,
      (history) => _stockHistory = history,
    );

    setIdle();
  }

  void clearSelection() {
    _selectedStockDetail = null;
    _stockHistory = [];
    _failure = null;
    notifyListeners();
  }
}
