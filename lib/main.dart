import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_todo_list/login_dialog.dart';
import 'package:firebase_todo_list/main_vm.dart';
import 'package:firebase_todo_list/repositories/authentication_repository.dart';
import 'package:firebase_todo_list/repositories/todo_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import 'data/todo.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // DIの設定
  GetIt.I.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  runApp(const ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.light,
          primarySwatch: Colors.lightBlue,
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(0xF2, 0xF2, 0xF2, 1.0),
        dialogBackgroundColor: const Color.fromRGBO(0xF2, 0xF2, 0xF2, 1.0),
      ),
      home: MyHomePage(title: 'Flutter Todo'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  static List<Color> colors = [
    Colors.white.withOpacity(0.8),
    Colors.red.withOpacity(0.2),
    Colors.green.withOpacity(0.2),
    Colors.blue.withOpacity(0.2),
    Colors.yellow.withOpacity(0.2),
    Colors.cyan.withOpacity(0.2),
  ];

  final formatDate = DateFormat('yyyy/MM/dd');

  static const circularEdge = Radius.circular(16.0);

  final _auth = AuthenticationRepository();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(mainVmProvider.notifier);

    return StreamBuilder(
        stream: _auth.uid(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const CircularProgressIndicator();
          }

          final userId = snapshot.data!;
          if (userId.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                  context: context, builder: (context) => const LoginDialog());
            });
            return const CircularProgressIndicator();
          }

          // ログインしている
          vm.onChangeUser(userId);

          return Scaffold(
            appBar: AppBar(),
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: () => _auth.signOut(),
                    child: const Text('ログアウト'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                              value: ref.watch(mainVmProvider
                                  .select((e) => e.visibleDoneItem)),
                              onChanged: vm.onVisibleDoneItem),
                        ),
                        const Text('実施済みも表示'),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: vm.onDescending,
                        child: Text(ref.watch(
                                mainVmProvider.select((e) => e.descending))
                            ? '締切 遅い'
                            : '締切 早い'))
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ref
                        .watch(todoRepositoryProvider(
                            userId: userId,
                            descending: vm.descending,
                            visibleDoneItem: vm.isDoneItemVisible))
                        .when(
                            error: (error, st) => Text(error.toString()),
                            loading: () => const CircularProgressIndicator(),
                            data: (data) {
                              final todos = data.docs
                                  .map((e) => Todo.fromJson(e.data()))
                                  .toList();
                              return ListView.builder(
                                itemCount: todos.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onLongPress: () => vm.onTodoLongTapped(
                                        todos[index],
                                        _confirmDelete(context, todos[index])),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: colors[todos[index].colorNo],
                                        borderRadius: BorderRadius.vertical(
                                          top: index == 0
                                              ? circularEdge
                                              : Radius.zero,
                                          bottom: index == todos.length - 1
                                              ? circularEdge
                                              : Radius.zero,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        child: Row(
                                          children: [
                                            Transform.scale(
                                              scale: 1.5,
                                              child: Checkbox(
                                                  value: todos[index].isDone,
                                                  shape: const CircleBorder(),
                                                  onChanged: (isChecked) =>
                                                      vm.onChangeTodoDone(
                                                          todos[index],
                                                          isChecked)),
                                            ),
                                            Text(
                                              todos[index].title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            Expanded(child: Container()),
                                            Text(
                                              todos[index].deadlineTime == null
                                                  ? ''
                                                  : formatDate.format(
                                                      todos[index]
                                                          .deadlineTime!),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                  ),
                ),
              ],
            )),

            floatingActionButton: FloatingActionButton(
              onPressed: () => _onAddTodo(context, vm),
              tooltip: 'add todo',
              child: const Icon(Icons.add),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        });
  }

  void _onAddTodo(BuildContext context, MainVm vm) {
    vm.onClearSheet();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            TextField(
              onChanged: vm.onChangeTitle,
            ),
            StatefulBuilder(builder: (context, setStateInSheet) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    child: vm.selectedDate == null
                        ? Row(
                            children: const [
                              Icon(Icons.calendar_month),
                              Text('期限'),
                            ],
                          )
                        : Text(formatDate.format(vm.selectedDate!)),
                    onPressed: () async {
                      final today = DateTime.now();
                      final date = await showDatePicker(
                        context: context,
                        initialDate: today,
                        firstDate: today.subtract(const Duration(days: 10)),
                        lastDate: today.add(const Duration(days: 100)),
                      );
                      vm.onChangeDateTime(date);
                    },
                  ),
                  for (int i = 0; i < colors.length; i++)
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 16.0,
                      child: Transform.scale(
                        scale: 1.5,
                        child: Radio<int>(
                          value: i,
                          groupValue: vm.selectedColor,
                          fillColor: MaterialStateProperty.all(
                              colors[i].withOpacity(1.0)),
                          onChanged: vm.onChangeColor,
                        ),
                      ),
                    ),
                  ElevatedButton(
                      onPressed: vm.title.isEmpty
                          ? null
                          : () async {
                              vm.onAddTodo();
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                      child: const Text('追加')),
                ],
              );
            }),
          ],
        );
      },
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, Todo todo) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('確認'),
              content: Text('「${todo.title}」を削除します'),
              actions: <Widget>[
                SimpleDialogOption(
                  child: const Text('キャンセル'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                SimpleDialogOption(
                  child: const Text('削除'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ));
  }
}
