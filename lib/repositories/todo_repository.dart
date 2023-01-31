import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import '../data/todo.dart';

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
  CollectionReference<Map<String, dynamic>> stream() {
    return _collection;
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

  Future<Todo?> find(String todoId) async {
    final doc = await _collection.doc(todoId).get();
    if (doc.exists) {
      return Todo.fromJson(doc.data()!);
    } else {
      return null;
      //      throw Exception('指定のTodoはありません: $todoId');
    }
  }
}
