import '../../../../core/data/prefix_search.dart';

abstract final class AdminSearch {
  static String normalize(String term) => PrefixSearch.normalize(term);

  static bool isActive(String term) => PrefixSearch.isActive(term);

  static List<String> namePrefixes(String term) {
    final String text = normalize(term);
    if (text.length < PrefixSearch.minLength || text.contains('@')) {
      return const [];
    }
    return PrefixSearch.nameVariants(text);
  }

  static String? emailPrefix(String term) {
    final String text = normalize(term);
    if (text.length < PrefixSearch.minLength || text.contains(' ')) {
      return null;
    }
    return text.toLowerCase();
  }
}
