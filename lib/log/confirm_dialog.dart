import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  static String _title = 'Are you sure to delete it?';

  static displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(_title),
            actions: <Widget>[
              new FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              new FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, false);
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
