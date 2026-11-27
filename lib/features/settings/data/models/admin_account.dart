import '../../../../core/data/admin_record.dart';

class AdminAccount {
  const AdminAccount({
    required this.record,
    this.lastSignInAt,
    this.isTwoStepEnabled = false,
  });

  final AdminRecord record;
  final DateTime? lastSignInAt;
  final bool isTwoStepEnabled;

  String get adminId => record.id;
  String get name => record.name;
  String get role => record.role.label;
  String get email => record.email;
  String get mobileNumber => record.phone;

  static bool isValidMobile(String value) {
    final String trimmed = value.trim();
    if (!RegExp(r'^\+?[\d\s-]+$').hasMatch(trimmed)) return false;
    final String digits = trimmed.replaceAll(RegExp(r'\D'), '');
    return digits.length == AdminRecord.phoneLength ||
        (digits.length == AdminRecord.phoneLength + 2 &&
            digits.startsWith('91'));
  }

  AdminAccount copyWith({AdminRecord? record}) => AdminAccount(
    record: record ?? this.record,
    lastSignInAt: lastSignInAt,
    isTwoStepEnabled: isTwoStepEnabled,
  );
}
