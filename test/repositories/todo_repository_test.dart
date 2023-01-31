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
}
