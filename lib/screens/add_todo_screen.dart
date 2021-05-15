import 'package:TODO/helpers/database_helper.dart';
import 'package:TODO/models/todo_models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddTodoScreen extends StatefulWidget {
  final Function updateTodoList;
  final int todoListLen;

  const AddTodoScreen({Key key, this.updateTodoList, this.todoListLen});

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formkey = GlobalKey<FormState>();
  String _title = '';
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _dateController.text = _dateFormatter.format(_date);
  }

  _selectDate() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
    );
    if (date != null) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(_date);
    }
  }

  _submit() {
    if (_formkey.currentState.validate()) {
      setState(() {
        _formkey.currentState.save();
        Todo todo = Todo(
            title: _title,
            date: _date,
            status: 0,
            priority: widget.todoListLen + 1);
        DatabaseHelper.instance.insertTodo(todo);
        widget.updateTodoList();
        Navigator.pop(context);
      });
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        " ADD",
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Colors.green,
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
                    validator: (input) => input.trim().isEmpty ? '' : null,
                    initialValue: _title,
                    onSaved: (input) => _title = input,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    style: GoogleFonts.poppins(fontSize: 18),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(height: 0),
                      labelStyle: GoogleFonts.poppins(),
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: TextFormField(
                    validator: (input) => input.trim().isEmpty ? '' : null,
                    controller: _dateController,
                    showCursor: true,
                    readOnly: true,
                    onTap: _selectDate,
                    style: GoogleFonts.poppins(fontSize: 18),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(height: 0),
                      labelStyle: GoogleFonts.poppins(),
                      labelText: 'Deadline',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                /*
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    height: 65,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: FlatButton(
                      child: Icon(Icons.check, color: Colors.white),
                    ),
                  ),
                ),

                 */
              ],
            ),
          );
        },
      ),
    );
  }
}
