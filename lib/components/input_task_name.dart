import 'package:flutter/material.dart';

class InputTaskName extends StatelessWidget {
  TextEditingController textEditingController;

  InputTaskName({required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: TextFormField(
        validator: (input) => input!.trim().isEmpty ? '' : null,
        controller: textEditingController,
        onSaved: (input) => textEditingController.text = input!,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
          errorStyle: TextStyle(height: 0),
          labelText: 'Task',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
