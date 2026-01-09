import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
