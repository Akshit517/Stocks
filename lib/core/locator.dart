import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stocks/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:stocks/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:stocks/features/auth/domain/auth_repository.dart';
import 'package:stocks/features/auth/presentation/view_models/auth_view_model.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory<AuthViewModel>(() => AuthViewModel(locator()));

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(locator(), locator()),
  );
  locator.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
}
