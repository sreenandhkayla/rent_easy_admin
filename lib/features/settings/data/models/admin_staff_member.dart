class AdminStaffMember {
  const AdminStaffMember({
    required this.adminId,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    this.lastSignInAt,
  });

  final String adminId;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final DateTime? lastSignInAt;

  AdminStaffMember copyWith({
    String? name,
    String? email,
    String? role,
    bool? isActive,
  }) {
    return AdminStaffMember(
      adminId: adminId,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      lastSignInAt: lastSignInAt,
    );
  }
}
