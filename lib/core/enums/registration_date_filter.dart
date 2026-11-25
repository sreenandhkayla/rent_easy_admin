import '../resources/strings/app_strings.dart';

enum RegistrationDateFilter {
  any(AppStrings.anyRegistrationDate),
  last30Days(AppStrings.registeredLast30Days),
  last90Days(AppStrings.registeredLast90Days),
  last12Months(AppStrings.registeredLast12Months);

  const RegistrationDateFilter(this.label);

  final String label;

  DateTime? since(DateTime now) => switch (this) {
    RegistrationDateFilter.any => null,
    RegistrationDateFilter.last30Days => now.subtract(const Duration(days: 30)),
    RegistrationDateFilter.last90Days => now.subtract(const Duration(days: 90)),
    RegistrationDateFilter.last12Months => DateTime(
      now.year - 1,
      now.month,
      now.day,
    ),
  };
}
