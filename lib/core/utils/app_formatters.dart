class AppFormatters {
  AppFormatters._();

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String number(int value) {
    final String digits = value.abs().toString();
    final StringBuffer buffer = StringBuffer(value < 0 ? '-' : '');
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  static String rupees(int value) {
    final String digits = value.abs().toString();
    if (digits.length <= 3) return '₹${value < 0 ? '-' : ''}$digits';
    final String lastThree = digits.substring(digits.length - 3);
    final String rest = digits.substring(0, digits.length - 3);
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < rest.length; i++) {
      if (i > 0 && (rest.length - i) % 2 == 0) buffer.write(',');
      buffer.write(rest[i]);
    }
    return '₹${value < 0 ? '-' : ''}$buffer,$lastThree';
  }

  static String rupeesLakh(int value, {int decimals = 1}) =>
      '₹${(value / 100000).toStringAsFixed(decimals)}L';

  static String percent(double fraction) =>
      '${(fraction * 100).toStringAsFixed(1)}%';

  static String monthShort(DateTime date) => _months[date.month - 1];

  static String dayMonth(DateTime date) =>
      '${_twoDigits(date.day)} ${_months[date.month - 1]}';

  static String date(DateTime date) =>
      '${_twoDigits(date.day)} ${_months[date.month - 1]} ${date.year}';

  static String dateTime(DateTime date) =>
      '${date.day} ${_months[date.month - 1]} ${date.year}, '
      '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';

  static String timestamp(DateTime date) =>
      '${AppFormatters.date(date)}, '
      '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');
}
