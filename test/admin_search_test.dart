import 'package:flutter_test/flutter_test.dart';
import 'package:rent_easy_admin/features/settings/data/models/admin_search.dart';

void main() {
  test('needs at least two characters', () {
    expect(AdminSearch.isActive('a'), isFalse);
    expect(AdminSearch.isActive(' ar '), isTrue);
    expect(AdminSearch.namePrefixes('a'), isEmpty);
    expect(AdminSearch.emailPrefix('a'), isNull);
  });

  test('a name searches as typed, lowercase and capitalized', () {
    expect(
      AdminSearch.namePrefixes('arjun ra'),
      containsAll(['arjun ra', 'Arjun Ra']),
    );
    expect(AdminSearch.namePrefixes('ARJ'), containsAll(['ARJ', 'arj', 'Arj']));
  });

  test('a single word also searches the lowercased email', () {
    expect(AdminSearch.emailPrefix('Arjun'), 'arjun');
    expect(AdminSearch.emailPrefix('arjun ra'), isNull);
  });

  test('an email only searches the email field', () {
    expect(AdminSearch.namePrefixes('Arjun@Team'), isEmpty);
    expect(AdminSearch.emailPrefix('Arjun@Team'), 'arjun@team');
  });
}
