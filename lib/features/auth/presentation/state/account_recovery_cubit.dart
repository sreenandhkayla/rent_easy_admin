import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/utils/app_validators.dart';
import 'account_recovery_state.dart';

class AccountRecoveryCubit extends Cubit<AccountRecoveryState> {
  AccountRecoveryCubit() : super(const AccountRecoveryState());

  void emailChanged() {
    if (state.emailError != null) {
      emit(AccountRecoveryState(status: state.status));
    }
  }

  void submit(String email) {
    if (state.status == AccountRecoveryStatus.submitting) return;
    if (!AppValidators.isValidEmail(email)) {
      emit(const AccountRecoveryState(emailError: AppStrings.invalidWorkEmail));
      return;
    }
    emit(const AccountRecoveryState(status: AccountRecoveryStatus.success));
  }
}
