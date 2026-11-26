import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/admin_role.dart';
import '../widgets/admin_shell/admin_section.dart';

class AdminRecord {
  const AdminRecord({
    this.id = '',
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    this.modules = const [],
    this.createdAt,
  });

  factory AdminRecord.fromDocument(Map<String, dynamic> data, String id) {
    final permissions = data[permissionsField];
    final createdAt = data[createdAtField];

    final email = normalizeEmail(
      _text(data[emailField]) ?? (id.contains('@') ? id : ''),
    );

    return AdminRecord(
      id: id,
      name: _text(data[nameField]) ?? email,
      email: email,
      role: roleFromKey(data[roleField]),
      phone: _text(data[phoneField]) ?? '',
      modules: permissions is List
          ? [
              for (final section in AdminSection.values)
                if (permissions.contains(section.name)) section,
            ]
          : const [],
      createdAt: createdAt is Timestamp ? createdAt.toDate() : null,
    );
  }

  static const String nameField = 'name';
  static const String emailField = 'email';
  static const String phoneField = 'phoneNumber';
  static const String roleField = 'role';
  static const String permissionsField = 'permissions';
  static const String createdAtField = 'createdAt';
  static const String updatedAtField = 'updatedAt';
  static const int minPasswordLength = 6;
  static const int phoneLength = 10;

  final String id;
  final String name;
  final String email;
  final AdminRole role;
  final String phone;
  final List<AdminSection> modules;
  final DateTime? createdAt;

  static AdminRole roleFromKey(Object? key) =>
      AdminRole.values.asNameMap()[key] ?? AdminRole.supportAdmin;

  static String normalizeEmail(String email) => email.trim().toLowerCase();

  static String phoneDigits(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length > phoneLength
        ? digits.substring(digits.length - phoneLength)
        : digits;
  }

  static String? _text(Object? value) {
    if (value is! String) return null;
    final text = value.trim();
    return text.isEmpty ? null : text;
  }

  static int oldestFirst(AdminRecord a, AdminRecord b) {
    final first = a.createdAt;
    final second = b.createdAt;
    if (first == null && second == null) return a.email.compareTo(b.email);
    if (first == null) return 1;
    if (second == null) return -1;
    return first.compareTo(second);
  }

  bool get hasAllModules => role == AdminRole.superAdmin;

  bool get canManageAdmins => canAccess(AdminSection.settings);

  bool get canChangeAdminPasswords => hasAllModules;

  bool get canGrantSuperAdmin => hasAllModules;

  List<AdminSection> get accessibleSections =>
      hasAllModules ? AdminSection.values : modules;

  bool canAccess(AdminSection section) => accessibleSections.contains(section);

  String? get homeRoute {
    for (final section in accessibleSections) {
      if (section.route case final route?) return route;
    }
    return null;
  }

  Map<String, Object?> toFields() => {
    nameField: name.trim(),
    emailField: normalizeEmail(email),
    phoneField: phone.trim(),
    roleField: role.name,
    permissionsField: [for (final section in accessibleSections) section.name],
  };

  AdminRecord copyWith({
    String? id,
    String? name,
    String? email,
    AdminRole? role,
    String? phone,
    List<AdminSection>? modules,
    DateTime? createdAt,
  }) {
    return AdminRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      modules: modules ?? this.modules,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
