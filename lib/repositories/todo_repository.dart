import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/todo.dart';

/// TODOのレポジトリ
class TodoRepository {
  late final _collection = FirebaseFirestore.instance
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
  Future<void> add(Todo newTodo) async {
    final doc = await _collection.add(newTodo.toJson());
    final newTodoWithId = newTodo.copyWith(id: doc.id);
    _collection.doc(newTodoWithId.id).update(newTodoWithId.toJson());
  }

  /// TODOを更新
  Future<void> update(Todo todo) async {
    _collection.doc(todo.id).update(todo.toJson());
  }
}
