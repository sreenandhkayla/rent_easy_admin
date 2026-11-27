import '../../../../core/data/admin_record.dart';
import '../../../../core/enums/admin_role.dart';

class AdminStaffMember {
  const AdminStaffMember(this.record);

  final AdminRecord record;

  String get adminId => record.id;
  String get name => record.name;
  String get email => record.email;
  AdminRole get adminRole => record.role;
  String get role => record.role.label;
  bool get isActive => record.isActive;
  DateTime? get lastSignInAt => record.lastSignInAt;
  bool get isSuperAdmin => record.role == AdminRole.superAdmin;
}
