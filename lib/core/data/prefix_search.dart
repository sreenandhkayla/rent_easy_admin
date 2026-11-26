import 'package:cloud_firestore/cloud_firestore.dart';

abstract final class PrefixSearch {
  static const int minLength = 2;
  static const int maxCaseInsensitiveLetters = 4;
  static const String _prefixEnd = '';

  static String normalize(String term) => term.trim();

  static bool isActive(String term) => normalize(term).length >= minLength;

  static Filter startsWithAny(Object field, List<String> prefixes) => prefixes
      .map(
        (prefix) => Filter.and(
          Filter(field, isGreaterThanOrEqualTo: prefix),
          Filter(field, isLessThan: '$prefix$_prefixEnd'),
        ),
      )
      .reduce(Filter.or);

  static List<String> nameVariants(String text) => {
    text,
    text.toLowerCase(),
    text
        .split(RegExp(r'\s+'))
        .map(
          (word) => word.isEmpty
              ? word
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' '),
  }.toList();

  static String caseInsensitivePrefix(String text) {
    int letters = 0;
    int end = 0;
    while (end < text.length) {
      if (_isLetter(text[end])) {
        if (letters == maxCaseInsensitiveLetters) break;
        letters++;
      }
      end++;
    }
    return text.substring(0, end);
  }

  static List<String> caseVariants(String text) {
    List<String> variants = [''];
    for (final String char in text.split('')) {
      final Set<String> options = {char.toLowerCase(), char.toUpperCase()};
      variants = [
        for (final String variant in variants)
          for (final String option in options) '$variant$option',
      ];
    }
    return variants;
  }

  static bool startsWithIgnoringCase(String value, String term) =>
      value.toLowerCase().startsWith(term.toLowerCase());

  static bool _isLetter(String char) =>
      char.toLowerCase() != char.toUpperCase();
}
