import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import '../data/todo.dart';

// ソート方法
enum SortMethod {
  deadlineTime,
  createdTime,
}

/// TODOのレポジトリ
class TodoRepository {
  late final _collection = GetIt.I<FirebaseFirestore>()
      .collection('todo')
      .doc(userId)
      .collection('user_todo');

  TodoRepository(this.userId);

  /// ユーザID
  final String userId;

  /// TODOを表示
  Query<Map<String, dynamic>> stream(
      {SortMethod? sortMethod, bool? descending, bool? isDone}) {
    Query<Map<String, dynamic>> collection = _collection;
    if (isDone != null) {
      collection = collection.where('isDone', isEqualTo: isDone);
    }
    if (sortMethod != null) {
      collection =
          collection.orderBy(sortMethod.name, descending: descending ?? false);
    }
    return collection;
  }

  Stream<List<Todo>> convert(Query<Map<String, dynamic>> stream) {
    return stream.snapshots().map((snapshots) =>
        snapshots.docs.map((doc) => Todo.fromJson(doc.data())).toList());
  }

  Stream<List<Todo>> streamAsList(
      {SortMethod? sortMethod, bool? descending, bool? isDone}) {
    return convert(
        stream(sortMethod: sortMethod, descending: descending, isDone: isDone));
  }

  /// TODOを追加
  Future<String> add(Todo newTodo) async {
    final doc = await _collection.add(newTodo.toJson());
    final newTodoWithId = newTodo.copyWith(id: doc.id);
    _collection.doc(newTodoWithId.id).update(newTodoWithId.toJson());

    return doc.id;
  }

  /// TODOを更新
  Future<void> update(Todo todo) async {
    _collection.doc(todo.id).update(todo.toJson());
  }

  /// TODOの検索
  Future<Todo?> find(String todoId) async {
    final doc = await _collection.doc(todoId).get();
    if (doc.exists) {
      return Todo.fromJson(doc.data()!);
    } else {
      return null;
      //      throw Exception('指定のTodoはありません: $todoId');
    }
  }

  /// TODOの削除
  Future<void> delete(String toodId) async {
    return _collection.doc(toodId).delete();
  }
}
