import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/admin_record.dart';
import '../../data/repositories/auth_repository.dart';
import 'admin_session_state.dart';

class AdminSessionCubit extends Cubit<AdminSessionState> {
  AdminSessionCubit(this._repository) : super(const AdminSessionState());

  final AuthRepository _repository;

  Future<void> restore() async {
    emit(const AdminSessionState());
    final result = await _repository.restoreSession();
    if (isClosed) return;

    result.match(
      (failure) => emit(
        AdminSessionState(
          status: AdminSessionStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (account) => emit(
        account == null
            ? const AdminSessionState(status: AdminSessionStatus.signedOut)
            : AdminSessionState(
                status: AdminSessionStatus.signedIn,
                account: account,
              ),
      ),
    );
  }

  void signedIn(AdminRecord account) => emit(
    AdminSessionState(status: AdminSessionStatus.signedIn, account: account),
  );

  void accountUpdated(AdminRecord account) {
    if (state.status != AdminSessionStatus.signedIn) return;
    if (state.account?.id != account.id) return;
    emit(
      AdminSessionState(status: AdminSessionStatus.signedIn, account: account),
    );
  }

  void signedOut() =>
      emit(const AdminSessionState(status: AdminSessionStatus.signedOut));
}
