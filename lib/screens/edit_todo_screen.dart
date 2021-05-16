import 'package:TODO/helpers/database_helper.dart';
import 'package:TODO/models/todo_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EditTodoScreen extends StatefulWidget {
  final Function updateTodoList;
  final Todo todo;
  final int todoListLen;

  const EditTodoScreen(
      {Key? key,
      required this.todo,
      required this.updateTodoList,
      required this.todoListLen})
      : super(key: key);

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final _formkey = GlobalKey<FormState>();
  String _title = '';
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _title = widget.todo.title;
    _date = widget.todo.date;
    _dateController.text = _dateFormatter.format(_date);
  }

  _selectDate() async {
    final DateTime date = (await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
    ))!;
    if (date != null) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(_date);
    }
  }

  _submit() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      Todo todo = Todo(
          title: _title,
          date: _date,
          status: widget.todo.status,
          priority: widget.todo.priority);
      todo.id = widget.todo.id;
      DatabaseHelper.instance.updateTodo(todo);
      widget.updateTodoList();
      Navigator.pop(context);
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteTodo(widget.todo.id!);
    widget.updateTodoList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 80),
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        "EDIT",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                        ),
                        onPressed: _delete,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Color(0xffff351a),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Color(0xff3DDC84),
                        ),
                        onPressed: _submit,
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
          return Form(
            key: _formkey,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: TextFormField(
                    validator: (input) => input!.trim().isEmpty ? '' : null,
                    initialValue: _title,
                    onSaved: (input) => _title = input!,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(height: 0),
                      labelText: 'Task',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: TextFormField(
                    validator: (input) => input!.trim().isEmpty ? '' : null,
                    controller: _dateController,
                    showCursor: true,
                    readOnly: true,
                    onTap: _selectDate,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(height: 0),
                      labelText: 'Deadline',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(08),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
