import 'package:flutter/material.dart';

class CostRemarks {
  int cost;
  String remarks;

  CostRemarks(this.cost, this.remarks);
}

class EditCostDialog extends StatelessWidget {
  String _title;
  CostRemarks _costRemarks;
  TextEditingController _costTextController;
  TextEditingController _remarksTextController;

  EditCostDialog(String title, CostRemarks costRemarks) {
    _title = title;
    _costRemarks = costRemarks;

    _costTextController = TextEditingController(
        text: _costRemarks.cost == null ? "" : _costRemarks.cost.toString());
    _remarksTextController = TextEditingController(text: _costRemarks.remarks);
  }

  displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(_title),
            content: new Container(
              height: 100.0,
              child: Column(
                children: <Widget>[
                  TextField(
                    autofocus: true,
                    controller: _costTextController,
                    decoration: InputDecoration(hintText: 'how much is cost?'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    autofocus: false,
                    controller: _remarksTextController,
                    decoration: InputDecoration(hintText: 'remarks?'),
                    keyboardType: TextInputType.text,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: Text('OK'),
                onPressed: () {
                  CostRemarks ret = new CostRemarks(
                      int.parse(_costTextController.text),
                      _remarksTextController.text);
                  Navigator.pop(context, ret);
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
