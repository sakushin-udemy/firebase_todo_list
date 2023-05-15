import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_list/data/todo.dart';
import 'package:firebase_todo_list/repositories/todo_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'main_model.dart';

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
  final _todoRepository = TodoRepository('user');

  @override
  MainModel build() => MainModel(newTodoDateTime: DateTime.now());

  bool get isDoneItemVisible => state.visibleDoneItem;

  bool get descending => state.descending;

  int get selectedColor => state.newTodoColor;

  DateTime? get selectedDate => state.newTodoDateTime;

  String get title => state.newTodoTitle;

  void onTitleChanged(String value) {
    state = state.copyWith(newTodoTitle: value);
  }

  void onColorChanged(int? value) {
    if (value == null) {
      return;
    }
    state = state.copyWith(newTodoColor: value);
  }

  void onSelectedDate(DateTime? value) {
    if (value == null) {
      return;
    }
    state = state.copyWith(newTodoDateTime: value);
  }

  void onVisibleDoneItem(bool? value) {
    if (value == null) {
      return;
    }
    state = state.copyWith(visibleDoneItem: value);
  }

  void onDescending() {
    state = state.copyWith(descending: !state.descending);
  }

  void onChangeIsDone(Todo todo, bool? value) {
    if (value == null) {
      return;
    }
    final newData = todo.copyWith(isDone: value);
    _todoRepository.update(newData);
  }

  void onCreateTodo() {
    final newTodo = Todo(
      id: '',
      title: state.newTodoTitle,
      isDone: false,
      colorNo: state.newTodoColor,
      deadlineTime: state.newTodoDateTime,
      createdTime: DateTime.now(),
    );
    _todoRepository.add(newTodo);
  }

  void onDeleteTodo(Todo todo) {
    _todoRepository.delete(todo.id);
  }
}