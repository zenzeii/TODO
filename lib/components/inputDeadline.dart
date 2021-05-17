import 'package:flutter/material.dart';

class InputDeadline extends StatelessWidget {
  final dynamic function;
  TextEditingController textEditingController;

  InputDeadline({required this.function, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: TextFormField(
        validator: (input) => input!.trim().isEmpty ? '' : null,
        controller: textEditingController,
        showCursor: true,
        readOnly: true,
        onTap: function,
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
          errorStyle: TextStyle(height: 0),
          labelText: 'Deadline',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
