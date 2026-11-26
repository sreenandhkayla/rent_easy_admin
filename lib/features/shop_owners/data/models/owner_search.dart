import 'package:flutter/foundation.dart';

import '../../../../core/data/prefix_search.dart';
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
      PrefixSearch.startsWithIgnoringCase(owner.ownerId, term);

  @override
  bool operator ==(Object other) =>
      other is OwnerIdSearch && other.term == term;

  @override
  int get hashCode => term.hashCode;
}

abstract final class OwnerSearch {
  static const int minLength = PrefixSearch.minLength;
  static const int maxCaseInsensitiveLetters =
      PrefixSearch.maxCaseInsensitiveLetters;
  static const String _countryCode = '91';
  static const int _localPhoneLength = 10;
  static final RegExp _phonePattern = RegExp(r'^[+\d\s-]+$');
  static final RegExp _nonDigits = RegExp(r'\D');

  static String normalize(String term) => PrefixSearch.normalize(term);

  static bool isActive(String term) => PrefixSearch.isActive(term);

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
      prefixes: PrefixSearch.nameVariants(text),
    );
  }

  static OwnerIdSearch? ownerIdFor(String term) {
    final String text = normalize(term);
    if (text.length < minLength || text.contains(' ') || _isPhone(text)) {
      return null;
    }
    return OwnerIdSearch(
      prefixes: PrefixSearch.caseVariants(
        PrefixSearch.caseInsensitivePrefix(text),
      ),
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
}
