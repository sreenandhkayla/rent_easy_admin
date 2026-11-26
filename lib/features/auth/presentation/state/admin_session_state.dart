import '../../../../core/data/admin_record.dart';

enum AdminSessionStatus { loading, signedIn, signedOut, failure }

class AdminSessionState {
  const AdminSessionState({
    this.status = AdminSessionStatus.loading,
    this.account,
    this.errorMessage,
  });

  final AdminSessionStatus status;
  final AdminRecord? account;
  final String? errorMessage;
}
