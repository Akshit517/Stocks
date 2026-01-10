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
      onModelReady: (model) {
        model.addListener(() {
          if (model.failure != null && mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(model.failure!.message)));
            model.clearFailure();
          }
        });
      },
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
            if (model.isBusy)
              const Padding(
                padding: EdgeInsets.only(top: 128),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (model.searchResults.isNotEmpty)
              _buildSearchResults(model)
            else
              _buildEmptyState(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.query_stats, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text("Search for a stock to see history"),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(StockViewModel model) {
    return ListView.builder(
      itemCount: model.searchResults.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final stock = model.searchResults[index];
        return ListTile(
          title: Text(stock.symbol),
          subtitle: Text(stock.name),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () {
            Navigation().navigateTo(
              RouteNames.stockdetail,
              arguments: {'title': stock.symbol},
            );
          },
        );
      },
    );
  }
}
