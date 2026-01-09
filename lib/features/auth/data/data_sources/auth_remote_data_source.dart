import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/core.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserCredential>> signInWithGoogle();

  Future<Either<Failure, void>> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(FirebaseAuthException e) verificationFailed,
  });

  Future<Either<Failure, UserCredential>> signInWithPhone({
    required String verificationId,
    required String smsCode,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._googleSignIn);

  @override
  Future<Either<Failure, UserCredential>> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();
      if (googleUser == null) {
        return left(const ServerFailure(message: 'Sign in aborted by user'));
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      return right(userCredential);
    } on FirebaseAuthException catch (e) {
      return left(ServerFailure(message: e.message ?? 'Firebase Auth Error'));
    } catch (e) {
      return left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(FirebaseAuthException e) verificationFailed,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e);
          verificationFailed(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          print("Code Sent");
          print(verificationId);
          codeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );

      return right(null);
    } catch (e) {
      print(e.toString());
      return left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signInWithPhone({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      return right(userCredential);
    } on FirebaseAuthException catch (e) {
      return left(
        ServerFailure(
          message: e.code == 'invalid-verification-code'
              ? 'The code you entered is incorrect.'
              : e.message ?? 'Authentication failed',
        ),
      );
    } catch (e) {
      return left(const ServerFailure(message: 'An unknown error occurred.'));
    }
  }
}
