import '../enums/admin_permission.dart';
import '../enums/admin_role.dart';
import '../widgets/admin_shell/admin_section.dart';

class RolePermissions {
  const RolePermissions._(this._granted);

  factory RolePermissions.defaults() => RolePermissions._({
    for (final AdminRole role in AdminRole.values)
      role: {
        for (final AdminPermission permission in AdminPermission.values)
          if (permission.isGranted(role)) permission,
      },
  });

  factory RolePermissions.fromDocument(Map<String, dynamic>? data) {
    final RolePermissions defaults = RolePermissions.defaults();
    if (data == null) return defaults;
    return RolePermissions._({
      for (final AdminRole role in AdminRole.values)
        role: switch (data[role.name]) {
          final List<Object?> stored when isRoleEditable(role) => {
            for (final AdminPermission permission in AdminPermission.values)
              if (stored.contains(permission.name)) permission,
          },
          _ => defaults._granted[role] ?? const {},
        },
    });
  }

  static const String collection = 'settings';
  static const String documentId = 'rolePermissions';
  static const String updatedAtField = 'updatedAt';
  static const String updatedByField = 'updatedBy';

  final Map<AdminRole, Set<AdminPermission>> _granted;

  static bool isRoleEditable(AdminRole role) => role != AdminRole.superAdmin;

  static bool isPagePermission(AdminPermission permission) =>
      AdminSection.values.any((section) => section.permission == permission);

  static bool isEditable(AdminRole role, AdminPermission permission) =>
      isRoleEditable(role);

  bool isGranted(AdminRole role, AdminPermission permission) =>
      !isRoleEditable(role) || (_granted[role]?.contains(permission) ?? false);

  List<AdminSection> sectionsFor(AdminRole role) => [
    for (final AdminSection section in AdminSection.values)
      if (section.permission == null || isGranted(role, section.permission!))
        section,
  ];

  List<String> moduleNamesFor(AdminRole role) => [
    for (final AdminSection section in sectionsFor(role)) section.name,
  ];

  Set<AdminPermission> actionsFor(AdminRole role) => {
    for (final AdminPermission permission in AdminPermission.values)
      if (!isPagePermission(permission) && isGranted(role, permission))
        permission,
  };

  List<String> permissionListFor(AdminRole role) => [
    ...moduleNamesFor(role),
    for (final AdminPermission permission in actionsFor(role)) permission.name,
  ];

  List<AdminRole> rolesWithoutPages() => [
    for (final AdminRole role in AdminRole.values)
      if (!sectionsFor(role).any((section) => section.route != null)) role,
  ];

  RolePermissions toggled(AdminRole role, AdminPermission permission) {
    if (!isEditable(role, permission)) return this;
    final Set<AdminPermission> current = {...?_granted[role]};
    if (!current.remove(permission)) current.add(permission);
    return RolePermissions._({..._granted, role: current});
  }

  Set<AdminRole> changedRoles(RolePermissions other) => {
    for (final AdminRole role in AdminRole.values)
      if (isRoleEditable(role) &&
          !_sameSet(_granted[role], other._granted[role]))
        role,
  };

  Map<String, Object?> toFields() => {
    for (final AdminRole role in AdminRole.values)
      if (isRoleEditable(role))
        role.name: [
          for (final AdminPermission permission in AdminPermission.values)
            if (isGranted(role, permission)) permission.name,
        ],
  };

  static bool _sameSet(Set<AdminPermission>? a, Set<AdminPermission>? b) {
    final Set<AdminPermission> first = a ?? const {};
    final Set<AdminPermission> second = b ?? const {};
    return first.length == second.length && first.containsAll(second);
  }
}
