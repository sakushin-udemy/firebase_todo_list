import 'package:firebase_todo_list/data/main_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'main_vm.g.dart';

@riverpod
class MainVm extends _$MainVm {
  @override
  MainModel build() => MainModel(newTodoDateTime: DateTime.now());
}
