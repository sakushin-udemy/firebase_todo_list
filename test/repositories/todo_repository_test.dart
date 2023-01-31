import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_todo_list/repositories/todo_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:firebase_todo_list/data/todo.dart';

main() {
  GetIt.I.registerFactory<FirebaseFirestore>(
    () => FakeFirebaseFirestore(),
  );

  late TodoRepository repository;

  setUp(() => repository = TodoRepository('user'));

  final todo1 = Todo(
    id: '',
    title: 'title1',
    isDone: false,
    colorNo: 1,
    deadlineTime: DateTime(2022, 1, 1),
    createdTime: DateTime(2022, 1, 2),
  );

  final todo2 = Todo(
    id: 'id2',
    title: 'title2',
    isDone: true,
    colorNo: 2,
    deadlineTime: DateTime(2022, 2, 1),
    createdTime: DateTime(2022, 2, 2),
  );

  test('追加とカウント', () async {
    final data = repository.stream();
    final result = data.count();
    expect((await result.get()).count, 0);

    await repository.add(todo1);
    expect((await data.count().get()).count, 1);

    await repository.add(todo2);
    expect((await data.count().get()).count, 2);
  });

  test('データの取得', () async {
    expect((await repository.stream().count().get()).count, 0);
    final data1_ = await repository.find('id1');
    expect(data1_, isNull);

    final todo1Id = await repository.add(todo1);
    expect((await repository.stream().count().get()).count, 1);

    final data1 = await repository.find(todo1Id);
    expect(data1, isNotNull);
    expect(data1!.id, todo1Id);
    expect(data1.title, 'title1');
    expect(data1.deadlineTime, DateTime(2022, 1, 1));
    expect(data1.createdTime, DateTime(2022, 1, 2));
  });

  test('データの削除', () async {
    expect((await repository.stream().count().get()).count, 0);
    final data1Id = await repository.add(todo1);
    expect((await repository.stream().count().get()).count, 1);

    await repository.delete(data1Id);
    expect((await repository.stream().count().get()).count, 0);

    await repository.delete(data1Id);
  });
}
