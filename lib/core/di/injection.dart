import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/state/admin_session_cubit.dart';
import '../../features/auth/presentation/state/auth_cubit.dart';
import '../../features/shop_owners/data/datasources/shop_owners_remote_data_source.dart';
import '../../features/subscriptions/data/datasources/plans_remote_data_source.dart';
import '../../features/subscriptions/data/repositories/plans_repository.dart';
import '../../features/subscriptions/presentation/state/create_plan_cubit.dart';
import '../../features/subscriptions/presentation/state/plan_details_cubit.dart';
import '../../features/subscriptions/presentation/state/subscriptions_cubit.dart';
import '../../features/subscriptions/presentation/state/subscriptions_state.dart';
import '../../features/shop_owners/data/repositories/shop_owners_repository.dart';
import '../../features/shop_owners/presentation/state/owner_details_cubit.dart';
import '../../features/shop_owners/presentation/state/shop_owners_cubit.dart';
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
    ..registerLazySingleton<ShopOwnersRemoteDataSource>(
      () => ShopOwnersRemoteDataSource(FirebaseFirestore.instance),
    )
    ..registerLazySingleton<PlansRemoteDataSource>(
      () => PlansRemoteDataSource(
        FirebaseFirestore.instance,
        FirebaseAuth.instance,
      ),
    )
    ..registerLazySingleton<PlansRepository>(
      () => PlansRepository(getIt<PlansRemoteDataSource>()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepository(
        getIt<AuthRemoteDataSource>(),
        getIt<AdminsRemoteDataSource>(),
      ),
    )
    ..registerFactory<ShopOwnersRepository>(
      () => ShopOwnersRepository(getIt<ShopOwnersRemoteDataSource>()),
    )
    ..registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()))
    ..registerFactory<AdminSessionCubit>(
      () => AdminSessionCubit(getIt<AuthRepository>()),
    )
    ..registerFactory<ShopOwnersCubit>(
      () => ShopOwnersCubit(getIt<ShopOwnersRepository>()),
    )
    ..registerFactoryParam<SubscriptionsCubit, SubscriptionsTab, void>(
      (tab, _) => SubscriptionsCubit(getIt<PlansRepository>(), initialTab: tab),
    )
    ..registerFactoryParam<CreatePlanCubit, String?, void>(
      (planId, _) => CreatePlanCubit(getIt<PlansRepository>(), planId: planId),
    )
    ..registerFactoryParam<PlanDetailsCubit, String?, void>(
      (planId, _) => PlanDetailsCubit(getIt<PlansRepository>(), planId),
    )
    ..registerFactoryParam<OwnerDetailsCubit, String?, void>(
      (ownerId, _) => OwnerDetailsCubit(getIt<ShopOwnersRepository>(), ownerId),
    );
}
