import 'dart:ui';

import '../../../../core/core.dart';
import '../../domain/auth_repository.dart';
import '../../domain/user.dart';

class AuthViewModel extends BaseViewModel {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  String? _verificationId;
  Failure? _failure;

  Failure? get failure => _failure;
  String? get verificationId => _verificationId;

  Future<void> signInWithGoogle({
    Function(AppUser)? onSuccess,
    Function(Failure)? onFailure,
  }) async {
    setLoading();
    _failure = null;
    final result = await _authRepository.signInWithGoogle();
    result.fold((failure) => _failure = failure, (user) => {});
    setIdle();
  }

  Future<void> sendOtp(
    String phone, {
    required Function(String) onSuccess,
  }) async {
    setLoading();

    final result = await _authRepository.startPhoneVerification(
      phoneNumber: phone,
      onCodeSent: (id) {
        _verificationId = id;
        setIdle();
        onSuccess(id);
      },
      onVerificationFailed: (f) {
        _failure = f;
        setIdle();
      },
    );

    result.mapLeft((f) => _failure = f);
    if (result.isLeft()) setIdle();
  }

  Future<void> verifyOtp(
    String verificationId,
    String smsCode, {
    required Function() onSuccess,
  }) async {
    setLoading();
    _failure = null;
    final result = await _authRepository.verifyOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    result.fold((failure) => _failure = failure, (_) => onSuccess());
    setIdle();
  }

  void clearFailure() {
    _failure = null;
  }

  Future<void> signOut({required VoidCallback onSuccess}) async {
    setLoading();
    _failure = null;
    final result = await _authRepository.signOut();
    result.fold((failure) => _failure = failure, (_) => onSuccess());
    setIdle();
  }
}
