import 'package:TODO/helpers/database_helper.dart';
import 'package:TODO/models/todo_models.dart';
import 'package:TODO/screens/about_screen.dart';
import 'package:TODO/screens/add_todo_screen.dart';
import 'package:TODO/screens/edit_todo_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Future<List<Todo>> _todoList;
  List<Todo> listOfSelected = [];
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  bool deleteMode = false;

  @override
  void initState() {
    super.initState();
    _updateTodoList();
  }

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

  Widget _ToDoTile(Todo todo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 40),
        title: Text(
          todo.title,
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          _dateFormatter.format(todo.date),
          style: GoogleFonts.poppins(),
        ),
        trailing: deleteMode
            ? IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    DatabaseHelper.instance.deleteTodo(todo.id);
                  });
                  _updateTodoList();
                })
            : Checkbox(
                onChanged: (value) {
                  setState(() {
                    todo.status = value ? 1 : 0;
                    DatabaseHelper.instance.updateTodo(todo);
                    _updateTodoList();
                  });
                },
                value: todo.status == 1,
              ),
        tileColor: Colors.green.withOpacity(0),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                EditTodoScreen(updateTodoList: _updateTodoList, todo: todo),
          ),
        ),
        onLongPress: () {
          setState(() {
            deleteMode = !deleteMode;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _todoList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 80),
            itemCount: 1 + snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
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
                              style: GoogleFonts.poppins(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          IconButton(
                            icon: deleteMode
                                ? Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.add,
                                    color: Colors.blue,
                                  ),
                            onPressed: () => deleteMode
                                ? _toggleDeleteMode()
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddTodoScreen(
                                        updateTodoList: _updateTodoList,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                );
              }
              return _ToDoTile(snapshot.data[index - 1]);
            },
          );
        },
      ),
    );
  }
}
