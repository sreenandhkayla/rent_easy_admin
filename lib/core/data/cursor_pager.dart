import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../errors/failure.dart';

typedef CursorPage<T> = ({
  List<T> items,
  DocumentSnapshot<Map<String, dynamic>>? last,
  bool hasMore,
});

typedef CursorPageFetcher<T> = Future<Either<Failure, CursorPage<T>>> Function(
  DocumentSnapshot<Map<String, dynamic>>? startAfter,
);

class CursorPager<T> {
  Object? _key;
  final List<List<T>> _pages = [];
  DocumentSnapshot<Map<String, dynamic>>? _lastDocument;
  bool _isExhausted = false;

  void clear() => _reset(null);

  void _reset(Object? key) {
    _key = key;
    _pages.clear();
    _lastDocument = null;
    _isExhausted = false;
  }

  Future<Either<Failure, List<T>>> page(
    Object key,
    int page,
    CursorPageFetcher<T> fetch,
  ) async {
    if (key != _key) _reset(key);
    while (_pages.length < page && !_isExhausted) {
      final result = await fetch(_lastDocument);
      if (key != _key) return right(const []);
      if (result case Left(:final value)) return left(value);
      final CursorPage<T> loaded = result.getOrElse(
        (_) => (items: const [], last: null, hasMore: false),
      );
      if (loaded.items.isEmpty) {
        _isExhausted = true;
        break;
      }
      _pages.add(loaded.items);
      _lastDocument = loaded.last;
      _isExhausted = !loaded.hasMore;
    }
    return right(page <= _pages.length ? _pages[page - 1] : const []);
  }
}
