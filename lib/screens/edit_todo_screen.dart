import 'package:TODO/components/header_edit_task.dart';
import 'package:TODO/components/input_task_deadline.dart';
import 'package:TODO/components/input_task_name.dart';
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
  TextEditingController _taskNameController = TextEditingController();
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _taskNameController.text = widget.todo.title;
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

  _editTask() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      Todo todo = Todo(
          title: _taskNameController.text,
          date: _date,
          status: widget.todo.status,
          priority: widget.todo.priority);
      todo.id = widget.todo.id;
      DatabaseHelper.instance.updateTodo(todo);
      widget.updateTodoList();
      Navigator.pop(context);
    }
  }

  _deleteTask() {
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
            return HeaderEditTask(
              editFunction: _editTask,
              deleteFunction: _deleteTask,
            );
          }
          return Form(
            key: _formkey,
            child: Column(
              children: [
                InputTaskName(
                  textEditingController: _taskNameController,
                ),
                InputTaskDeadline(
                  function: _selectDate,
                  textEditingController: _dateController,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
