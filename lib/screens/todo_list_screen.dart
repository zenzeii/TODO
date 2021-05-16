import 'dart:ui';
import 'package:TODO/helpers/database_helper.dart';
import 'package:TODO/models/todo_models.dart';
import 'package:TODO/screens/about_screen.dart';
import 'package:TODO/screens/add_todo_screen.dart';
import 'package:TODO/screens/edit_todo_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late Future<List<Todo>> _todoList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  bool deleteMode = false;

  @override
  void initState() {
    super.initState();
    _updateTodoList();
  }

  // functions here
  _updateTodoList() {
    setState(() {
      _todoList = DatabaseHelper.instance.getTodoList();
    });
  }

  _toggleDeleteMode() {
    setState(() {
      deleteMode = !deleteMode;
    });
  }

  // widgets here
  Widget _toDoTile(Todo todo, int listLen) {
    return Padding(
      key: ValueKey(todo),
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 40),
        title: Text(
          todo.title,
        ),
        subtitle: Text(
          _dateFormatter.format(todo.date),
        ),
        trailing: deleteMode
            ? IconButton(
                icon: Icon(
                  Icons.delete_outline,
                ),
                onPressed: () {
                  setState(() {
                    DatabaseHelper.instance.deleteTodo(todo.id);
                  });
                  _updateTodoList();
                })
            : Checkbox(
                activeColor: Color(0xff3DDC84),
                onChanged: (value) {
                  setState(() {
                    todo.status = value! ? 1 : 0;
                    DatabaseHelper.instance.updateTodo(todo);
                    _updateTodoList();
                  });
                },
                value: todo.status == 1,
              ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditTodoScreen(
                updateTodoList: _updateTodoList,
                todoListLen: listLen,
                todo: todo),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _todoList,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AboutScreen(),
                          ),
                        ),
                        child: Text(
                          "TODO",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        icon: deleteMode
                            ? Icon(
                                Icons.check,
                                color: Color(0xff3DDC84),
                              )
                            : Icon(
                                Icons.add,
                              ),
                        onPressed: () => deleteMode
                            ? _toggleDeleteMode()
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddTodoScreen(
                                    updateTodoList: _updateTodoList,
                                    todoListLen: 0,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      alignment: AlignmentDirectional.center,
                      height: double.infinity,
                      child: Column(
                        children: [
                          Expanded(child: Container()),
                          CircularProgressIndicator(),
                          Expanded(child: Container()),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "If this doesn't end please delete app data.",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return ReorderableListView.builder(
              padding: EdgeInsets.symmetric(),
              itemCount: 1 + snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    key: ValueKey(0),
                    padding:
                        const EdgeInsets.only(left: 40.0, right: 40.0, top: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AboutScreen(),
                                ),
                              ),
                              child: Text(
                                "TODO",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            GestureDetector(
                              onLongPress: _toggleDeleteMode,
                              child: IconButton(
                                icon: deleteMode
                                    ? Icon(
                                        Icons.check,
                                        color: Color(0xff3DDC84),
                                      )
                                    : Icon(
                                        Icons.add,
                                      ),
                                onPressed: () => deleteMode
                                    ? _toggleDeleteMode()
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AddTodoScreen(
                                            updateTodoList: _updateTodoList,
                                            todoListLen: snapshot.data.length,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        snapshot.data.length == 0
                            ? Container(
                                alignment: AlignmentDirectional.center,
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "• tap '+' to add new task \n"
                                      "• tap task tile to edit task \n"
                                      "• tap 'TODO' to learn about us \n"
                                      "• tap & hold task tile to edit priority\n"
                                      "• tap & hold '+' to switch to delete mode\n"
                                      "• tap task tile checkbox to mark as done",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  );
                }
                return _toDoTile(
                    snapshot.data[index - 1], snapshot.data.length);
              },
              onReorder: (oldIndex, newIndex) => setState(() {
                if (newIndex != 0 && oldIndex != 0) {
                  // because of header
                  oldIndex -= 1;
                  newIndex -= 1;

                  // drag down
                  if (newIndex > oldIndex) {
                    newIndex -= 1;

                    // new priority
                    snapshot.data[oldIndex].priority = newIndex + 1;
                    DatabaseHelper.instance.updateTodo(snapshot.data[oldIndex]);

                    // others one to the top
                    for (int i = oldIndex + 1; i < newIndex + 1; i++) {
                      snapshot.data[i].priority = i;
                      DatabaseHelper.instance.updateTodo(snapshot.data[i]);
                    }
                  }

                  // drag up
                  if (oldIndex > newIndex) {
                    // others one to the bot
                    for (int i = newIndex; i < oldIndex + 1; i++) {
                      snapshot.data[i].priority = i + 2;
                      DatabaseHelper.instance.updateTodo(snapshot.data[i]);
                    }
                    // new priority
                    snapshot.data![oldIndex].priority = newIndex + 1;
                    DatabaseHelper.instance.updateTodo(snapshot.data[oldIndex]);
                  }

                  // this is to prevent to flicker (reset positions until updateTODOList)
                  final tile = snapshot.data!.removeAt(oldIndex);
                  snapshot.data?.insert(newIndex, tile);

                  _updateTodoList();
                }
              }),
            );
          }
        },
      ),
    );
  }
}
