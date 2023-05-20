import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_list/data/main_model.dart';
import 'package:firebase_todo_list/repositories/todo_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'data/todo.dart';
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

  void onChangeUser(String userId) {
    _todoRepository = TodoRepository(userId);
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

  void onClearSheet() {
    state = state.copyWith(
        newTodoTitle: '', newTodoColor: 0, newTodoDateTime: null);
  }

  void onChangeTitle(String value) {
    state = state.copyWith(newTodoTitle: value);
  }

  void onChangeColor(int? value) {
    if (value == null) {
      return;
    }

    state = state.copyWith(newTodoColor: value);
  }

  void onChangeDateTime(DateTime? value) {
    if (value == null) {
      return;
    }
    state = state.copyWith(newTodoDateTime: value);
  }

  void onAddTodo() {
    assert(_todoRepository != null);

    final newTodo = Todo(
      id: '',
      title: title,
      isDone: false,
      colorNo: selectedColor,
      deadlineTime: selectedDate,
      createdTime: DateTime.now(),
    );
    _todoRepository!.add(newTodo);
  }

  void onChangeTodoDone(Todo todo, bool? value) {
    assert(_todoRepository != null);
    if (value == null) {
      return;
    }

    final newData = todo.copyWith(isDone: value);
    _todoRepository!.update(newData);
  }

  void onTodoLongTapped(Todo todo, Future<bool?> confirmDelete) {
    assert(_todoRepository != null);

    confirmDelete.then((result) {
      if (result != true) {
        return;
      }
      _todoRepository!.delete(todo.id);
    });
  }
}
