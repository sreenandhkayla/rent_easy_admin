import 'package:fpdart/fpdart.dart';

import '../../../../core/access/role_permissions.dart';
import '../../../../core/data/admin_record.dart';
import '../../../../core/data/admins_remote_data_source.dart';
import '../../../../core/enums/admin_role.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../../auth/data/datasources/auth_remote_data_source.dart';
import '../models/admin_search.dart';
import '../models/admin_staff_member.dart';
import 'role_permissions_repository.dart';

typedef AdminStaffContext = ({
  List<AdminStaffMember> staff,
  AdminStaffMember? actor,
});

typedef AddedAdmin = ({AdminStaffMember member, bool isNewLogin});

class AdminStaffRepository {
  const AdminStaffRepository(
    this._adminsDataSource,
    this._authDataSource,
    this._rolePermissions,
  );

  final AdminsRemoteDataSource _adminsDataSource;
  final AuthRemoteDataSource _authDataSource;
  final RolePermissionsRepository _rolePermissions;

  Future<Either<Failure, List<AdminStaffMember>>> fetchStaff() async {
    final result = await _adminsDataSource.fetchAll();
    return result.map(
      (records) => [for (final record in records) AdminStaffMember(record)],
    );
  }

  Future<Either<Failure, List<AdminStaffMember>>> searchStaff(
    String term,
  ) async {
    final List<String> namePrefixes = AdminSearch.namePrefixes(term);
    final String? emailPrefix = AdminSearch.emailPrefix(term);
    final results = await Future.wait([
      if (namePrefixes.isNotEmpty)
        _adminsDataSource.searchByPrefix(AdminRecord.nameField, namePrefixes),
      if (emailPrefix != null)
        _adminsDataSource.searchByPrefix(AdminRecord.emailField, [emailPrefix]),
    ]);
    for (final result in results) {
      if (result case Left(:final value)) return left(value);
    }
    final Map<String, AdminRecord> matches = {
      for (final result in results)
        for (final AdminRecord record in result.getOrElse((_) => const []))
          record.id: record,
    };
    return right([
      for (final AdminRecord record
          in matches.values.toList()..sort(AdminRecord.oldestFirst))
        AdminStaffMember(record),
    ]);
  }

  Future<Either<Failure, AdminStaffContext>> fetchContext() async {
    final results = await Future.wait([
      fetchStaff(),
      _authDataSource.currentSignIn(),
    ]);
    final staffResult = results[0] as Either<Failure, List<AdminStaffMember>>;
    final signInResult = results[1] as Either<Failure, AdminSignIn?>;
    if (staffResult case Left(:final value)) return left(value);
    if (signInResult case Left(:final value)) return left(value);
    final List<AdminStaffMember> staff = staffResult.getOrElse((_) => const []);
    final String? email = switch (signInResult.getOrElse((_) => null)) {
      final AdminSignIn signIn => AdminRecord.normalizeEmail(signIn.email),
      null => null,
    };
    return right((
      staff: staff,
      actor: staff.where((member) => member.email == email).firstOrNull,
    ));
  }

  static bool isLastActiveSuperAdmin(
    List<AdminStaffMember> staff,
    String adminId,
  ) {
    final List<AdminStaffMember> active = staff
        .where((member) => member.isActive && member.isSuperAdmin)
        .toList();
    return active.length == 1 && active.first.adminId == adminId;
  }

  Future<Either<Failure, bool>> emailExists(
    String email, {
    String? exceptAdminId,
  }) async {
    final result = await _adminsDataSource.findByEmail(email);
    return result.map((record) => record != null && record.id != exceptAdminId);
  }

  Future<Either<Failure, AddedAdmin>> addAdmin({
    required String name,
    required String email,
    required String password,
    required AdminRole role,
    required bool isActive,
  }) async {
    final context = await fetchContext();
    if (context case Left(:final value)) return left(value);
    final AdminStaffMember? actor = context
        .getOrElse((_) => (staff: const [], actor: null))
        .actor;
    if (role == AdminRole.superAdmin && actor?.isSuperAdmin != true) {
      return left(const DataFailure(SettingsStrings.superAdminOnly));
    }
    final taken = await emailExists(email);
    if (taken case Left(:final value)) return left(value);
    if (taken.getOrElse((_) => true)) {
      return left(const DataFailure(SettingsStrings.emailTaken));
    }
    final permissions = await _rolePermissions.fetch();
    if (permissions case Left(:final value)) return left(value);
    final RolePermissions roles = permissions.getOrElse(
      (_) => RolePermissions.defaults(),
    );
    final String normalizedEmail = AdminRecord.normalizeEmail(email);
    final login = await _authDataSource.createLogin(normalizedEmail, password);
    if (login case Left(:final value)) return left(value);
    final AdminRecord record = AdminRecord(
      name: name.trim(),
      email: normalizedEmail,
      role: role,
      phone: '',
      modules: roles.sectionsFor(role),
      actions: roles.actionsFor(role),
      isActive: isActive,
      createdAt: DateTime.now(),
    );
    final created = await _adminsDataSource.createAdmin(record);
    return created.map(
      (id) => (
        member: AdminStaffMember(record.copyWith(id: id)),
        isNewLogin: login.getOrElse((_) => false),
      ),
    );
  }

  Future<Either<Failure, AdminStaffMember>> updateAdmin(
    AdminStaffMember member, {
    required String name,
    required AdminRole role,
    required bool isActive,
  }) async {
    final AdminRecord current = member.record;
    final bool roleChanged = role != current.role;
    RolePermissions roles = RolePermissions.defaults();
    if (roleChanged) {
      final permissions = await _rolePermissions.fetch();
      if (permissions case Left(:final value)) return left(value);
      roles = permissions.getOrElse((_) => roles);
    }
    final String newName = name.trim();
    final Map<String, Object?> fields = {
      if (newName != current.name) AdminRecord.nameField: newName,
      if (roleChanged) AdminRecord.roleField: role.name,
      if (roleChanged)
        AdminRecord.permissionsField: roles.permissionListFor(role),
      if (roleChanged)
        AdminRecord.permissionsVersionField:
            AdminRecord.currentPermissionsVersion,
      if (isActive != current.isActive) AdminRecord.isActiveField: isActive,
    };
    if (fields.isEmpty) return right(member);
    final result = await _adminsDataSource.updateAdmin(current.id, fields);
    if (result case Left(:final value)) return left(value);
    final reread = await _adminsDataSource.fetchById(current.id);
    final AdminRecord fallback = current.copyWith(
      name: newName,
      role: role,
      modules: roleChanged ? roles.sectionsFor(role) : null,
      actions: roleChanged ? roles.actionsFor(role) : null,
      isActive: isActive,
    );
    return right(
      AdminStaffMember(
        reread.match((_) => fallback, (record) => record ?? fallback),
      ),
    );
  }

  Future<Either<Failure, Unit>> removeAdmin(AdminStaffMember member) =>
      _adminsDataSource.deleteAdmin(member.adminId);
}
