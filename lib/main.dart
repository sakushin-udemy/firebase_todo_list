import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'data/todo.dart';

void main() async {
  runApp(const MyApp());
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
      ),
      home: const MyHomePage(title: 'Flutter Todo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static List<Color> colors = [
    Colors.white.withOpacity(0.8),
    Colors.red.withOpacity(0.2),
    Colors.green.withOpacity(0.2),
    Colors.blue.withOpacity(0.2),
    Colors.yellow.withOpacity(0.2),
    Colors.cyan.withOpacity(0.2),
  ];

  String _title = '';
  int _selectedColor = 0;
  DateTime? _selectedDateTime = DateTime.now();
  final formatDate = DateFormat('yyyy/MM/dd');

  List<Todo> todo = [
    Todo(
      id: '1',
      title: 'あいうえお',
      isDone: false,
      colorNo: 0,
      deadlineTime: DateTime(2023, 5, 5),
      createdTime: DateTime(2023, 1, 5),
    ),
    Todo(
      id: '2',
      title: 'かきくけこ',
      isDone: true,
      colorNo: 1,
      deadlineTime: DateTime(2023, 5, 5),
      createdTime: DateTime(2023, 1, 5),
    ),
    Todo(
      id: '3',
      title: 'さしすせそ',
      isDone: false,
      colorNo: 2,
      deadlineTime: DateTime(2023, 5, 5),
      createdTime: DateTime(2023, 1, 5),
    )
  ];

  static const circularEdge = Radius.circular(16.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: todo.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: colors[todo[index].colorNo],
                        borderRadius: BorderRadius.vertical(
                          top: index == 0 ? circularEdge : Radius.zero,
                          bottom: index == todo.length - 1
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
                                value: todo[index].isDone,
                                shape: const CircleBorder(),
                                onChanged: (isChecked) =>
                                    _onChangeIsDone(index, isChecked),
                              ),
                            ),
                            Text(
                              todo[index].title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTodo,
        tooltip: 'add todo',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onAddTodo() {
    _selectedColor = 0;
    _selectedDateTime = null;
    _title = '';
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            TextField(
              onChanged: (value) => _title = value,
            ),
            StatefulBuilder(builder: (context, setStateInSheet) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    child: _selectedDateTime == null
                        ? Row(
                            children: const [
                              Icon(Icons.calendar_month),
                              Text('期限'),
                            ],
                          )
                        : Text(formatDate.format(_selectedDateTime!)),
                    onPressed: () async {
                      final today = DateTime.now();
                      final date = await showDatePicker(
                        context: context,
                        initialDate: today,
                        firstDate: today.subtract(const Duration(days: 10)),
                        lastDate: today.add(const Duration(days: 100)),
                      );
                      if (date != null) {
                        setStateInSheet(() {
                          _selectedDateTime = date;
                        });
                      }
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
                          groupValue: _selectedColor,
                          fillColor: MaterialStateProperty.all(
                              colors[i].withOpacity(1.0)),
                          onChanged: (int? index) {
                            if (index != null) {
                              setStateInSheet(() {
                                _selectedColor = index;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ElevatedButton(
                      onPressed: _title.isEmpty
                          ? null
                          : () {
                              final newTodo = Todo(
                                id: '',
                                title: _title,
                                isDone: false,
                                colorNo: _selectedColor,
                                deadlineTime: _selectedDateTime,
                                createdTime: DateTime.now(),
                              );

                              setState(() {
                                todo.add(newTodo);
                              });

                              Navigator.pop(context);
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

  void _onChangeIsDone(int index, bool? isChecked) {
    if (isChecked == null) {
      return;
    }
    setState(() {
      todo[index] = todo[index].copyWith(isDone: isChecked);
    });
  }
}
