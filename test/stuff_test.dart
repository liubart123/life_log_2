import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Cloning colletcions', () {
    final mapCollection = {
      'e1': 'e1v',
      'e2': 'e2v',
    };
    final clonedCollection = Map<String, String>.from(mapCollection);
    checkMapCollectionsEquity(
      mapCollection,
      clonedCollection,
      expectedResult: true,
    );
    //checking equality after changing one of collections
    clonedCollection['e1'] = 'e1v updated';

    checkMapCollectionsEquity(
      mapCollection,
      clonedCollection,
      expectedResult: false,
    );
  });
}

void checkMapCollectionsEquity(
  Map<String, String> collection1,
  Map<String, String> collection2, {
  required bool expectedResult,
}) {
  expect(
    collection1.length,
    collection2.length,
    reason: 'cloned map collections aren`t equal',
  );
  for (final value1 in collection1.values) {
    expect(
      collection1[value1],
      collection2[value1],
      reason: 'cloned map collections aren`t equal',
    );
  }
}
