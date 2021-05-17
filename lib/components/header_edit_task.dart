import 'package:flutter/material.dart';

class HeaderEditTask extends StatelessWidget {
  final dynamic editFunction;
  final dynamic deleteFunction;

  HeaderEditTask({required this.editFunction, required this.deleteFunction});

  @override
  Widget build(BuildContext context) {
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
                onPressed: deleteFunction,
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
                onPressed: editFunction,
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
}
