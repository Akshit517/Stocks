import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String id;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;

  AppUser({
    required this.id,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
  });

  factory AppUser.fromFirebase(User firebaseUser) {
    return AppUser(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      phoneNumber: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoURL,
    );
  }
}
