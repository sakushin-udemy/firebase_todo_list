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
    id: '',
    title: 'title2',
    isDone: true,
    colorNo: 2,
    deadlineTime: DateTime(2022, 2, 1),
    createdTime: DateTime(2022, 2, 2),
  );

  final todo3 = Todo(
    id: '',
    title: 'title3',
    isDone: false,
    colorNo: 2,
    deadlineTime: DateTime(2022, 3, 1),
    createdTime: DateTime(2022, 1, 1),
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
  test('ソート方法', () async {
    expect(SortMethod.values, [
      SortMethod.deadlineTime,
      SortMethod.createdTime,
    ]);

    expect(SortMethod.createdTime.name, 'createdTime');
  });
  test('ソート createdTime', () async {
    expect(
        (await repository
                .stream(sortMethod: SortMethod.createdTime)
                .count()
                .get())
            .count,
        0);
    await Future.wait([todo1, todo2, todo3].map(repository.add));
    expect(
        (await repository
                .stream(sortMethod: SortMethod.createdTime)
                .count()
                .get())
            .count,
        3);

    final dataSortedByCreateDate =
        await repository.stream(sortMethod: SortMethod.createdTime).get();
    final list = dataSortedByCreateDate.docs
        .map(
          (e) => Todo.fromJson(e.data()),
        )
        .toList();
    expect(list[0].title, todo3.title);
    expect(list[1].title, todo1.title);
    expect(list[2].title, todo2.title);
  });

  test('ソート deadlineTime 昇順', () async {
    await Future.wait([todo1, todo2, todo3].map(repository.add));

    final dataSortedByCreateDate =
        await repository.stream(sortMethod: SortMethod.deadlineTime).get();
    final list = dataSortedByCreateDate.docs
        .map(
          (e) => Todo.fromJson(e.data()),
        )
        .toList();
    expect(list[0].title, todo1.title);
    expect(list[1].title, todo2.title);
    expect(list[2].title, todo3.title);
  });

  test('ソート deadlineTime 降順', () async {
    await Future.wait([todo1, todo2, todo3].map(repository.add));

    final dataSortedByCreateDate = await repository
        .stream(sortMethod: SortMethod.deadlineTime, descending: true)
        .get();
    final list = dataSortedByCreateDate.docs
        .map(
          (e) => Todo.fromJson(e.data()),
        )
        .toList();
    expect(list[0].title, todo3.title);
    expect(list[1].title, todo2.title);
    expect(list[2].title, todo1.title);
  });
}
