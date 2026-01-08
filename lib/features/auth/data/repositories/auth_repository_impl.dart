import 'package:fpdart/fpdart.dart';

import '../../../../core/core.dart';
import '../../domain/auth_repository.dart';
import '../../domain/user.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AppUser>> signInWithGoogle() async {
    final result = await remoteDataSource.signInWithGoogle();

    return result.map((credential) => AppUser.fromFirebase(credential.user!));
  }

  @override
  Future<Either<Failure, void>> startPhoneVerification({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(Failure failure) onVerificationFailed,
  }) async {
    return await remoteDataSource.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, resendToken) {
        onCodeSent(verificationId);
      },
      verificationFailed: (firebaseException) {
        onVerificationFailed(
          ServerFailure(
            message: firebaseException.message ?? 'Phone verification failed',
          ),
        );
      },
    );
  }

  @override
  Future<Either<Failure, AppUser>> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final result = await remoteDataSource.signInWithPhone(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return result.map((credential) => AppUser.fromFirebase(credential.user!));
  }
}
