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

  Future<void> signInWithGoogle() async {
    setLoading();
    _failure = null;

    final result = await _authRepository.signInWithGoogle();

    result.fold(
      (failure) => _failure = failure,
      (user) => _handleSuccess(user),
    );

    setIdle();
  }

  Future<void> sendOtp(String phone) async {
    setLoading();

    final result = await _authRepository.startPhoneVerification(
      phoneNumber: phone,
      onCodeSent: (id) {
        _verificationId = id;
        setIdle();
      },
      onVerificationFailed: (f) {
        _failure = f;
        setIdle();
      },
    );

    result.mapLeft((f) => _failure = f);
    if (result.isLeft()) setIdle();
  }

  void _handleSuccess(AppUser user) {}
}
