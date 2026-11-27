import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../../features/dashboard/data/repositories/dashboard_repository.dart';
import '../../features/dashboard/presentation/state/dashboard_cubit.dart';
import '../../features/notifications/data/datasources/notifications_remote_data_source.dart';
import '../../features/notifications/data/repositories/notifications_repository.dart';
import '../../features/notifications/presentation/state/create_notification_cubit.dart';
import '../../features/notifications/presentation/state/notification_details_cubit.dart';
import '../../features/notifications/presentation/state/notifications_cubit.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/state/admin_session_cubit.dart';
import '../../features/auth/presentation/state/auth_cubit.dart';
import '../../features/auth/presentation/state/change_password_cubit.dart';
import '../../features/settings/data/datasources/platform_settings_remote_data_source.dart';
import '../../features/settings/data/datasources/role_permissions_remote_data_source.dart';
import '../../features/settings/data/repositories/admin_profile_repository.dart';
import '../../features/settings/data/repositories/admin_staff_repository.dart';
import '../../features/settings/data/repositories/platform_settings_repository.dart';
import '../../features/settings/data/repositories/role_permissions_repository.dart';
import '../../features/settings/presentation/state/add_admin_cubit.dart';
import '../../features/settings/presentation/state/edit_profile_cubit.dart';
import '../../features/settings/presentation/state/manage_admin_cubit.dart';
import '../../features/settings/presentation/state/platform_branding_cubit.dart';
import '../../features/settings/presentation/state/settings_cubit.dart';
import '../../features/settings/presentation/state/settings_state.dart';
import '../../features/shop_owners/data/datasources/shop_owners_remote_data_source.dart';
import '../../features/shops/data/datasources/shops_remote_data_source.dart';
import '../../features/shops/data/repositories/shops_repository.dart';
import '../../features/shops/presentation/state/shop_details_cubit.dart';
import '../../features/shops/presentation/state/shops_cubit.dart';
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
    ..registerLazySingleton<ShopsRemoteDataSource>(
      () => ShopsRemoteDataSource(FirebaseFirestore.instance),
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
    ..registerLazySingleton<AdminProfileRepository>(
      () => AdminProfileRepository(
        getIt<AuthRemoteDataSource>(),
        getIt<AdminsRemoteDataSource>(),
      ),
    )
    ..registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSource(
        FirebaseFirestore.instance,
        FirebaseAuth.instance,
      ),
    )
    ..registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepository(getIt<NotificationsRemoteDataSource>()),
    )
    ..registerFactory<NotificationsCubit>(
      () => NotificationsCubit(getIt<NotificationsRepository>()),
    )
    ..registerFactoryParam<CreateNotificationCubit, String?, void>(
      (draftId, _) =>
          CreateNotificationCubit(getIt<NotificationsRepository>(), draftId),
    )
    ..registerFactoryParam<NotificationDetailsCubit, String?, void>(
      (id, _) => NotificationDetailsCubit(getIt<NotificationsRepository>(), id),
    )
    ..registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSource(FirebaseFirestore.instance),
    )
    ..registerLazySingleton<DashboardRepository>(
      () => DashboardRepository(getIt<DashboardRemoteDataSource>()),
    )
    ..registerFactory<DashboardCubit>(
      () => DashboardCubit(getIt<DashboardRepository>()),
    )
    ..registerLazySingleton<PlatformSettingsRemoteDataSource>(
      () => PlatformSettingsRemoteDataSource(FirebaseFirestore.instance),
    )
    ..registerLazySingleton<PlatformSettingsRepository>(
      () =>
          PlatformSettingsRepository(getIt<PlatformSettingsRemoteDataSource>()),
    )
    ..registerLazySingleton<RolePermissionsRemoteDataSource>(
      () => RolePermissionsRemoteDataSource(FirebaseFirestore.instance),
    )
    ..registerLazySingleton<RolePermissionsRepository>(
      () => RolePermissionsRepository(getIt<RolePermissionsRemoteDataSource>()),
    )
    ..registerLazySingleton<AdminStaffRepository>(
      () => AdminStaffRepository(
        getIt<AdminsRemoteDataSource>(),
        getIt<AuthRemoteDataSource>(),
        getIt<RolePermissionsRepository>(),
      ),
    )
    ..registerFactory<ShopOwnersRepository>(
      () => ShopOwnersRepository(getIt<ShopOwnersRemoteDataSource>()),
    )
    ..registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()))
    ..registerFactory<ChangePasswordCubit>(
      () => ChangePasswordCubit(getIt<AuthRepository>()),
    )
    ..registerFactory<AdminSessionCubit>(
      () => AdminSessionCubit(getIt<AuthRepository>()),
    )
    ..registerFactory<ShopOwnersCubit>(
      () => ShopOwnersCubit(getIt<ShopOwnersRepository>()),
    )
    ..registerFactory<ShopsRepository>(
      () => ShopsRepository(
        getIt<ShopsRemoteDataSource>(),
        getIt<PlansRepository>(),
      ),
    )
    ..registerFactoryParam<ShopsCubit, String, void>(
      (initialQuery, _) =>
          ShopsCubit(getIt<ShopsRepository>(), initialQuery: initialQuery),
    )
    ..registerFactoryParam<ShopDetailsCubit, String?, void>(
      (shopId, _) => ShopDetailsCubit(getIt<ShopsRepository>(), shopId),
    )
    ..registerFactoryParam<SettingsCubit, SettingsTab, void>(
      (tab, _) => SettingsCubit(
        getIt<AdminProfileRepository>(),
        getIt<AdminStaffRepository>(),
        getIt<RolePermissionsRepository>(),
        getIt<PlatformSettingsRepository>(),
        initialTab: tab,
      ),
    )
    ..registerFactory<PlatformBrandingCubit>(
      () => PlatformBrandingCubit(getIt<PlatformSettingsRepository>()),
    )
    ..registerFactory<AddAdminCubit>(
      () => AddAdminCubit(getIt<AdminStaffRepository>()),
    )
    ..registerFactoryParam<ManageAdminCubit, String?, void>(
      (adminId, _) => ManageAdminCubit(getIt<AdminStaffRepository>(), adminId),
    )
    ..registerFactory<EditProfileCubit>(
      () => EditProfileCubit(getIt<AdminProfileRepository>()),
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
