import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_list/data/main_model.dart';
import 'package:firebase_todo_list/repositories/todo_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'main_vm.g.dart';

@riverpod
Stream<QuerySnapshot<Map<String, dynamic>>> todoRepository(
  ref, {
  required String userId,
  required bool visibleDoneItem,
  required bool descending,
}) {
  return TodoRepository(userId)
      .stream(
        isDone: visibleDoneItem ? null : false,
        sortMethod: SortMethod.deadlineTime,
        descending: descending,
      )
      .snapshots();
}

@riverpod
class MainVm extends _$MainVm {
  TodoRepository? _todoRepository;

  @override
  MainModel build() => MainModel(newTodoDateTime: DateTime.now());

  bool get isDoneItemVisible => state.visibleDoneItem;

  bool get descending => state.descending;

  int get selectedColor => state.newTodoColor;

  DateTime? get selectedDate => state.newTodoDateTime;

  String get title => state.newTodoTitle;
}
