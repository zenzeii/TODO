import 'package:TODO/components/inputDeadline.dart';
import 'package:TODO/components/add_task_header.dart';
import 'package:TODO/components/input_task_name.dart';
import 'package:TODO/helpers/database_helper.dart';
import 'package:TODO/models/todo_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTodoScreen extends StatefulWidget {
  final Function updateTodoList;
  final int todoListLen;
  const AddTodoScreen(
      {Key? key, required this.updateTodoList, required this.todoListLen});

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _taskNameController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _dateController.text = _dateFormatter.format(_date);
  }

  void _selectDate() async {
    final DateTime date = (await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
    ))!;
    setState(() {
      _date = date;
    });
    _dateController.text = _dateFormatter.format(_date);
  }

  void _addTask() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _formKey.currentState!.save();
        Todo todo = Todo(
            title: _taskNameController.text,
            date: _date,
            status: 0,
            priority: widget.todoListLen + 1);
        DatabaseHelper.instance.insertTodo(todo);
        widget.updateTodoList();
        Navigator.pop(context);
      });
    } else {
      _formKey.currentState!.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 80),
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return AddTaskHeader(function: () {
              _addTask();
            });
          }
          return Form(
            key: _formKey,
            child: Column(
              children: [
                InputTaskName(
                  textEditingController: _taskNameController,
                ),
                InputDeadline(
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
