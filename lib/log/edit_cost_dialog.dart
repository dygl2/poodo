import 'package:flutter/material.dart';

class EditCostDialog extends StatelessWidget {
  String _title;
  TextEditingController _textController = TextEditingController();

  EditCostDialog(this._title);

  displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(_title),
            content: TextField(
              autofocus: true,
              controller: _textController,
              decoration: InputDecoration(hintText: 'how much is cost?'),
              keyboardType: TextInputType.number,
            ),
            actions: <Widget>[
              new FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context, _textController.text);
                },
              ),
              new FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
