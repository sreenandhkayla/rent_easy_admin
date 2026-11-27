import 'package:flutter_test/flutter_test.dart';
import 'package:rent_easy_admin/core/access/role_permissions.dart';
import 'package:rent_easy_admin/core/enums/admin_permission.dart';
import 'package:rent_easy_admin/core/enums/admin_role.dart';
import 'package:rent_easy_admin/core/widgets/admin_shell/admin_section.dart';

void main() {
  test('defaults match the built-in role matrix', () {
    final RolePermissions defaults = RolePermissions.defaults();
    for (final AdminRole role in AdminRole.values) {
      for (final AdminPermission permission in AdminPermission.values) {
        expect(
          defaults.isGranted(role, permission),
          permission.isGranted(role),
          reason: '${role.name} / ${permission.name}',
        );
      }
    }
  });

  test('a missing document falls back to the defaults', () {
    final RolePermissions loaded = RolePermissions.fromDocument(null);
    expect(loaded.changedRoles(RolePermissions.defaults()), isEmpty);
  });

  test('super admin cannot be changed and opens every page', () {
    final RolePermissions toggled = RolePermissions.defaults().toggled(
      AdminRole.superAdmin,
      AdminPermission.manageStaff,
    );
    expect(
      toggled.isGranted(AdminRole.superAdmin, AdminPermission.manageStaff),
      isTrue,
    );
    expect(toggled.sectionsFor(AdminRole.superAdmin), AdminSection.values);
  });

  test('every permission can be toggled for non-super roles', () {
    final RolePermissions defaults = RolePermissions.defaults();
    for (final AdminPermission permission in AdminPermission.values) {
      expect(
        defaults
            .toggled(AdminRole.supportAdmin, permission)
            .changedRoles(defaults),
        {AdminRole.supportAdmin},
        reason: permission.name,
      );
    }
  });

  test('action permissions are listed alongside page names', () {
    final RolePermissions permissions = RolePermissions.defaults().toggled(
      AdminRole.supportAdmin,
      AdminPermission.managePlans,
    );
    final List<String> list = permissions.permissionListFor(
      AdminRole.supportAdmin,
    );
    expect(list, contains(AdminSection.dashboard.name));
    expect(list, contains(AdminPermission.managePlans.name));
    expect(list, isNot(contains(AdminPermission.viewDashboard.name)));
  });

  test('toggling a page permission changes that role and its modules', () {
    final RolePermissions defaults = RolePermissions.defaults();
    final RolePermissions toggled = defaults.toggled(
      AdminRole.supportAdmin,
      AdminPermission.sendNotifications,
    );
    expect(toggled.changedRoles(defaults), {AdminRole.supportAdmin});
    expect(
      toggled.moduleNamesFor(AdminRole.supportAdmin),
      contains(AdminSection.notifications.name),
    );
    expect(
      defaults.moduleNamesFor(AdminRole.supportAdmin),
      isNot(contains(AdminSection.notifications.name)),
    );
    expect(
      toggled
          .toggled(AdminRole.supportAdmin, AdminPermission.sendNotifications)
          .changedRoles(defaults),
      isEmpty,
    );
  });

  test('a role with no page permissions is reported', () {
    RolePermissions permissions = RolePermissions.defaults();
    expect(permissions.rolesWithoutPages(), isEmpty);
    for (final AdminPermission permission in AdminPermission.values) {
      if (permissions.isGranted(AdminRole.operationsAdmin, permission) &&
          RolePermissions.isPagePermission(permission)) {
        permissions = permissions.toggled(
          AdminRole.operationsAdmin,
          permission,
        );
      }
    }
    expect(permissions.rolesWithoutPages(), [AdminRole.operationsAdmin]);
    expect(
      permissions.sectionsFor(AdminRole.operationsAdmin),
      isNot(contains(AdminSection.dashboard)),
    );
  });

  test('a saved document round-trips', () {
    final RolePermissions edited = RolePermissions.defaults()
        .toggled(AdminRole.operationsAdmin, AdminPermission.manageStaff)
        .toggled(AdminRole.supportAdmin, AdminPermission.reviewReports);
    final RolePermissions reloaded = RolePermissions.fromDocument(
      edited.toFields(),
    );
    expect(reloaded.changedRoles(edited), isEmpty);
    expect(
      reloaded.isGranted(
        AdminRole.operationsAdmin,
        AdminPermission.manageStaff,
      ),
      isTrue,
    );
    expect(
      reloaded.isGranted(AdminRole.supportAdmin, AdminPermission.reviewReports),
      isFalse,
    );
  });
}
