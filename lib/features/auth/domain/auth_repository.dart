import 'package:fpdart/fpdart.dart';

import '../../../core/core.dart';
import 'user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> signInWithGoogle();

  Future<Either<Failure, void>> startPhoneVerification({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(Failure failure) onVerificationFailed,
  });

  Future<Either<Failure, AppUser>> verifyOtp({
    required String verificationId,
    required String smsCode,
  });
}
