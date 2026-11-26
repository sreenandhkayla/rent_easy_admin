import 'package:flutter/foundation.dart';

import 'shop_owner.dart';

class OwnerSearchQuery {
  const OwnerSearchQuery({required this.field, required this.prefixes});

  final String field;
  final List<String> prefixes;

  @override
  bool operator ==(Object other) =>
      other is OwnerSearchQuery &&
      other.field == field &&
      listEquals(other.prefixes, prefixes);

  @override
  int get hashCode => Object.hash(field, Object.hashAll(prefixes));
}

class OwnerIdSearch {
  const OwnerIdSearch({required this.prefixes, required this.term});

  final List<String> prefixes;
  final String term;

  bool matches(ShopOwner owner) =>
      owner.ownerId.toLowerCase().startsWith(term.toLowerCase());

  @override
  bool operator ==(Object other) =>
      other is OwnerIdSearch && other.term == term;

  @override
  int get hashCode => term.hashCode;
}

abstract final class OwnerSearch {
  static const int minLength = 2;
  static const int maxCaseInsensitiveLetters = 4;
  static const String _countryCode = '91';
  static const int _localPhoneLength = 10;
  static final RegExp _phonePattern = RegExp(r'^[+\d\s-]+$');
  static final RegExp _nonDigits = RegExp(r'\D');

  static String normalize(String term) => term.trim();

  static bool isActive(String term) => normalize(term).length >= minLength;

  static bool _isPhone(String text) =>
      _phonePattern.hasMatch(text) &&
      text.replaceAll(_nonDigits, '').isNotEmpty;

  static OwnerSearchQuery? queryFor(String term) {
    final String text = normalize(term);
    if (text.length < minLength) return null;
    if (_isPhone(text)) {
      return OwnerSearchQuery(
        field: ShopOwner.phoneField,
        prefixes: [_phonePrefix(text)],
      );
    }
    return OwnerSearchQuery(
      field: ShopOwner.nameField,
      prefixes: _nameVariants(text).toList(),
    );
  }

  static OwnerIdSearch? ownerIdFor(String term) {
    final String text = normalize(term);
    if (text.length < minLength || text.contains(' ') || _isPhone(text)) {
      return null;
    }
    int letters = 0;
    int end = 0;
    while (end < text.length) {
      if (_isLetter(text[end])) {
        if (letters == maxCaseInsensitiveLetters) break;
        letters++;
      }
      end++;
    }
    return OwnerIdSearch(
      prefixes: _caseVariants(text.substring(0, end)),
      term: text,
    );
  }

  static String _phonePrefix(String text) {
    final String digits = text.replaceAll(_nonDigits, '');
    final bool hasCountryCode =
        text.startsWith('+') ||
        (digits.length > _localPhoneLength && digits.startsWith(_countryCode));
    return hasCountryCode ? '+$digits' : '+$_countryCode$digits';
  }

  static Set<String> _nameVariants(String text) => {
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
  };

  static bool _isLetter(String char) =>
      char.toLowerCase() != char.toUpperCase();

  static List<String> _caseVariants(String text) {
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
}
