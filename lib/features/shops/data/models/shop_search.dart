import 'package:flutter/foundation.dart';

import '../../../../core/data/prefix_search.dart';

class ShopNameSearch {
  const ShopNameSearch(this.prefixes);

  final List<String> prefixes;

  @override
  bool operator ==(Object other) =>
      other is ShopNameSearch && listEquals(other.prefixes, prefixes);

  @override
  int get hashCode => Object.hashAll(prefixes);
}

class ShopIdSearch {
  const ShopIdSearch({required this.prefixes, required this.term});

  final List<String> prefixes;
  final String term;

  bool matches(String value) =>
      PrefixSearch.startsWithIgnoringCase(value, term);

  @override
  bool operator ==(Object other) => other is ShopIdSearch && other.term == term;

  @override
  int get hashCode => term.hashCode;
}

abstract final class ShopSearch {
  static String normalize(String term) => PrefixSearch.normalize(term);

  static bool isActive(String term) => PrefixSearch.isActive(term);

  static ShopNameSearch? nameFor(String term) {
    final String text = normalize(term);
    if (!isActive(text)) return null;
    return ShopNameSearch(PrefixSearch.nameVariants(text));
  }

  static ShopIdSearch? idFor(String term) {
    final String text = normalize(term);
    if (!isActive(text) || text.contains(' ')) return null;
    return ShopIdSearch(
      prefixes: PrefixSearch.caseVariants(
        PrefixSearch.caseInsensitivePrefix(text),
      ),
      term: text,
    );
  }
}
