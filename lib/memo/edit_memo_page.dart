import 'package:flutter/material.dart';
import 'package:poodo/memo/memo.dart';

class EditMemoPage extends StatelessWidget {
  final Memo _memo;
  final Function _onChanged;

  EditMemoPage(this._memo, this._onChanged);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Edit Memo'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Icon(Icons.check),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
          leading: FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Icon(Icons.arrow_back_ios),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ),
        body: new Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            new TextField(
              autofocus: true,
              controller: TextEditingController(text: _memo.title),
              decoration: InputDecoration(
                labelText: "memo title",
              ),
              keyboardType: TextInputType.text,
              maxLines: 2,
              style: new TextStyle(color: Colors.black),
              onChanged: (text) {
                _memo.title = text;
                _onChanged(_memo);
              },
            ),
            new TextField(
              controller: TextEditingController(text: _memo.content),
              decoration: InputDecoration(
                labelText: "memo content",
              ),
              maxLines: 20,
              style: new TextStyle(color: Colors.black),
              onChanged: (text) {
                _memo.content = text;
                _onChanged(_memo);
              },
            ),
          ]),
        ));
  }
}
