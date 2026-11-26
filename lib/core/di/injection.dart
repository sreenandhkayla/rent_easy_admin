import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/state/admin_session_cubit.dart';
import '../../features/auth/presentation/state/auth_cubit.dart';
import '../data/admins_remote_data_source.dart';

final GetIt getIt = GetIt.instance;

void configureDependencies() {
  getIt
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(FirebaseAuth.instance),
    )
    ..registerLazySingleton<AdminsRemoteDataSource>(
      () => AdminsRemoteDataSource(FirebaseFirestore.instance),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepository(
        getIt<AuthRemoteDataSource>(),
        getIt<AdminsRemoteDataSource>(),
      ),
    )
    ..registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()))
    ..registerFactory<AdminSessionCubit>(
      () => AdminSessionCubit(getIt<AuthRepository>()),
    );
}
