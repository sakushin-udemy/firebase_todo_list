import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_todo_list/data/db_user.dart';
import 'package:firebase_todo_list/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

main() {
  GetIt.I.registerFactory<FirebaseFirestore>(
    () => FakeFirebaseFirestore(),
  );

  late UserRepository repository;

  setUp(() => repository = UserRepository());

  test('ユーザ作成と確認', () async {
    const dbUser = DbUser(
      authenticationId: 'authenticationId',
      loginName: 'loginName',
      email: 'email',
      nickname: 'nickname',
    );

    await repository.add(dbUser);

    final result = await repository.find('authenticationId');
    expect(result.authenticationId, 'authenticationId');
    expect(result.loginName, 'loginName');
    expect(result.email, 'email');
    expect(result.nickname, 'nickname');
  });

  test('存在しないユーザを見ると、エラー', () async {
    expect(() => repository.find('no user'), throwsA(isA<Exception>()));
  });
}
