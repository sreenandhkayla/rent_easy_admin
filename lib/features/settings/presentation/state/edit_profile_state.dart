import '../../data/models/admin_account.dart';

class EditProfileState {
  const EditProfileState({
    required this.account,
    required this.name,
    required this.mobileNumber,
    required this.updatedAt,
    this.showErrors = false,
  });

  static const int minMobileDigits = 10;

  final AdminAccount account;
  final String name;
  final String mobileNumber;
  final DateTime updatedAt;
  final bool showErrors;

  bool get isNameValid => name.trim().isNotEmpty;

  bool get isMobileValid {
    final String value = mobileNumber.trim();
    final int digits = value.replaceAll(RegExp(r'\D'), '').length;
    return RegExp(r'^\+?[\d\s-]+$').hasMatch(value) &&
        digits >= minMobileDigits;
  }

  bool get showNameError => showErrors && !isNameValid;

  bool get showMobileError => showErrors && !isMobileValid;

  EditProfileState copyWith({
    AdminAccount? account,
    String? name,
    String? mobileNumber,
    DateTime? updatedAt,
    bool? showErrors,
  }) {
    return EditProfileState(
      account: account ?? this.account,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      updatedAt: updatedAt ?? this.updatedAt,
      showErrors: showErrors ?? this.showErrors,
    );
  }
}
