class AdminAccount {
  const AdminAccount({
    required this.adminId,
    required this.name,
    required this.role,
    required this.email,
    required this.mobileNumber,
    required this.lastSignInAt,
    required this.lastSignInPlace,
    required this.isTwoStepEnabled,
  });

  final String adminId;
  final String name;
  final String role;
  final String email;
  final String mobileNumber;
  final DateTime lastSignInAt;
  final String lastSignInPlace;
  final bool isTwoStepEnabled;

  AdminAccount copyWith({
    String? name,
    String? email,
    String? role,
    String? mobileNumber,
  }) {
    return AdminAccount(
      adminId: adminId,
      name: name ?? this.name,
      role: role ?? this.role,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      lastSignInAt: lastSignInAt,
      lastSignInPlace: lastSignInPlace,
      isTwoStepEnabled: isTwoStepEnabled,
    );
  }
}
