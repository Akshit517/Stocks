import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isDisposed = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  bool get isBusy => _isLoading;

  void reload() {
    if (!_isDisposed) notifyListeners();
  }

  void setLoading() {
    _isLoading = true;
    reload();
  }

  void setIdle() {
    _isLoading = false;
    reload();
  }
}
