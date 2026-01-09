import 'package:flutter/material.dart';
import '../widgets/logout_button.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/user.dart';
import '../viewmodels/stock_view_model.dart';

class StockView extends StatefulWidget {
  final AppUser user;
  const StockView({super.key, required this.user});

  @override
  State<StockView> createState() => _StockViewState();
}

class _StockViewState extends State<StockView> {
  late final TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<StockViewModel>(
      builder: (context, model, child) => ResponsiveScaffold(
        title: "Market Explorer",
        actions: [LogoutButton()],
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search ticker (e.g. AAPL)",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => model.searchStocks(searchController.text),
                  ),
                ),
                onSubmitted: (value) => model.searchStocks(value),
              ),
            ),

            const SizedBox(height: 20),

            Stack(
              children: [
                if (model.searchResults.isNotEmpty &&
                    model.selectedStockDetail == null)
                  _buildSearchResults(model),

                if (model.selectedStockDetail != null)
                  _buildStockDetails(model),

                if (model.isBusy)
                  const Center(child: CircularProgressIndicator()),

                if (!model.isBusy &&
                    model.searchResults.isEmpty &&
                    model.selectedStockDetail == null)
                  const Center(
                    child: Text("Search for a stock to see history"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(StockViewModel model) {
    return ListView.builder(
      itemCount: model.searchResults.length,
      itemBuilder: (context, index) {
        final stock = model.searchResults[index];
        return ListTile(
          title: Text(stock.symbol),
          subtitle: Text(stock.name),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () {
            // Defaulting to 1-day interval when first selecting
            model.getStockDetails(symbol: stock.symbol, interval: '1d');
          },
        );
      },
    );
  }

  Widget _buildStockDetails(StockViewModel model) {
    final detail = model.selectedStockDetail!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                detail.symbol,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => model.clearSelection(),
              ),
            ],
          ),
          Text("${detail.sector} • ${detail.industry}"),
          const SizedBox(height: 20),

          // --- CHART AREA ---
          Container(
            height: 250,
            width: double.infinity,
            color: Colors.grey[200],
            child: const Center(
              child: Text("Stock Chart (Use Syncfusion or FlChart here)"),
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "About",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(detail.description),
        ],
      ),
    );
  }
}
