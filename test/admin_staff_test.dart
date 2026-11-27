import 'package:flutter_test/flutter_test.dart';
import 'package:rent_easy_admin/core/data/admin_record.dart';
import 'package:rent_easy_admin/core/enums/admin_permission.dart';
import 'package:rent_easy_admin/core/enums/admin_role.dart';
import 'package:rent_easy_admin/core/widgets/admin_shell/admin_section.dart';
import 'package:rent_easy_admin/features/settings/data/models/admin_staff_member.dart';
import 'package:rent_easy_admin/features/settings/data/repositories/admin_staff_repository.dart';

AdminStaffMember _member(String id, AdminRole role, {bool isActive = true}) =>
    AdminStaffMember(
      AdminRecord(
        id: id,
        name: id,
        email: '$id@example.com',
        role: role,
        phone: '',
        isActive: isActive,
      ),
    );

void main() {
  group('AdminRecord', () {
    test('treats a missing isActive as active', () {
      final AdminRecord record = AdminRecord.fromDocument({
        'name': 'Asha',
        'email': 'Asha@Example.com',
        'role': 'supportAdmin',
        'permissions': ['dashboard'],
      }, 'a1');
      expect(record.isActive, isTrue);
      expect(record.email, 'asha@example.com');
    });

    test('reads isActive false', () {
      final AdminRecord record = AdminRecord.fromDocument({
        'email': 'b@example.com',
        'isActive': false,
      }, 'b1');
      expect(record.isActive, isFalse);
    });

    test('gives each role modules it can open', () {
      expect(AdminRecord.permissionsFor(AdminRole.superAdmin), [
        for (final section in AdminSection.values) section.name,
      ]);
      final List<AdminSection> support = AdminRecord.modulesFor(
        AdminRole.supportAdmin,
      );
      expect(support, contains(AdminSection.dashboard));
      expect(support, isNot(contains(AdminSection.settings)));
      final AdminRecord record = AdminRecord(
        email: 'c@example.com',
        name: 'C',
        role: AdminRole.operationsAdmin,
        phone: '',
        modules: AdminRecord.modulesFor(AdminRole.operationsAdmin),
      );
      expect(record.homeRoute, isNotNull);
      expect(
        record.toFields()['permissions'],
        AdminRecord.permissionsFor(AdminRole.operationsAdmin),
      );
    });
  });

  group('AdminRecord.can', () {
    test('legacy documents get their role default actions', () {
      final AdminRecord operations = AdminRecord.fromDocument({
        'email': 'o@example.com',
        'role': 'operationsAdmin',
        'permissions': ['dashboard', 'subscriptions'],
      }, 'o1');
      expect(operations.can(AdminPermission.managePlans), isTrue);
      final AdminRecord support = AdminRecord.fromDocument({
        'email': 's@example.com',
        'role': 'supportAdmin',
        'permissions': ['dashboard', 'subscriptions'],
      }, 's1');
      expect(support.can(AdminPermission.managePlans), isFalse);
    });

    test('saved documents use exactly the stored actions', () {
      final AdminRecord record = AdminRecord.fromDocument({
        'email': 'o@example.com',
        'role': 'operationsAdmin',
        'permissions': ['dashboard', 'restrictOwnersAndShops'],
        'permissionsVersion': AdminRecord.currentPermissionsVersion,
      }, 'o1');
      expect(record.can(AdminPermission.restrictOwnersAndShops), isTrue);
      expect(record.can(AdminPermission.managePlans), isFalse);
      expect(record.can(AdminPermission.viewDashboard), isTrue);
      expect(record.can(AdminPermission.viewSubscriptions), isFalse);
    });

    test('toFields writes actions and the version', () {
      final AdminRecord record = AdminRecord(
        email: 'x@example.com',
        name: 'X',
        role: AdminRole.supportAdmin,
        phone: '',
        modules: const [AdminSection.dashboard],
        actions: const {AdminPermission.platformSettings},
      );
      final Map<String, Object?> fields = record.toFields();
      expect(fields['permissions'], ['dashboard', 'platformSettings']);
      expect(
        fields['permissionsVersion'],
        AdminRecord.currentPermissionsVersion,
      );
      final AdminRecord reread = AdminRecord.fromDocument(
        Map<String, dynamic>.from(fields),
        'x1',
      );
      expect(reread.can(AdminPermission.platformSettings), isTrue);
    });

    test('super admins can do everything', () {
      const AdminRecord record = AdminRecord(
        email: 'y@example.com',
        name: 'Y',
        role: AdminRole.superAdmin,
        phone: '',
      );
      for (final AdminPermission permission in AdminPermission.values) {
        expect(record.can(permission), isTrue, reason: permission.name);
      }
    });
  });

  group('isLastActiveSuperAdmin', () {
    test('is true only for the single active super admin', () {
      final staff = [
        _member('s1', AdminRole.superAdmin),
        _member('s2', AdminRole.superAdmin, isActive: false),
        _member('o1', AdminRole.operationsAdmin),
      ];
      expect(AdminStaffRepository.isLastActiveSuperAdmin(staff, 's1'), isTrue);
      expect(AdminStaffRepository.isLastActiveSuperAdmin(staff, 's2'), isFalse);
      expect(AdminStaffRepository.isLastActiveSuperAdmin(staff, 'o1'), isFalse);
    });

    test('is false when two super admins are active', () {
      final staff = [
        _member('s1', AdminRole.superAdmin),
        _member('s2', AdminRole.superAdmin),
      ];
      expect(AdminStaffRepository.isLastActiveSuperAdmin(staff, 's1'), isFalse);
    });
  });
}
