import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  test('Firestore Compare Data', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('users').add({
      'uid': 'someuid',
      'name': 'Bob',
      'email': 'bob@somedomain.com'
    });

    final mockUserUid = 'someuid';
    final mockUserName = 'Bob';
    final mockUserEmail = 'bob@somedomain.com';

    await firestore.collection('users').get().then((value) {
      value.docs.forEach((element){
        // Comment the three following lines to fail the tests
        expect(mockUserUid, element.data()['uid']);
        expect(mockUserName, element.data()['name']);
        expect(mockUserEmail, element.data()['email']);

        // Fail on purpose (comment to pass the tests)
        // expect('testFail', element.data()['uid']);
      });
    });
  });
}