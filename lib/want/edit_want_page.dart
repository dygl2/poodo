import 'package:flutter/material.dart';
import 'package:poodo/want/want.dart';

class EditWantPage extends StatelessWidget {
  final Want _want;
  final Function _onChanged;

  EditWantPage(this._want, this._onChanged);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Edit Want'),
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
              controller: TextEditingController(text: _want.title),
              decoration: InputDecoration(
                labelText: "want title",
              ),
              maxLines: 2,
              style: new TextStyle(color: Colors.black),
              onChanged: (text) {
                _want.title = text;
                _onChanged(_want);
              },
            ),
            new TextField(
              controller: TextEditingController(text: _want.content),
              decoration: InputDecoration(
                labelText: "want content",
              ),
              maxLines: 20,
              style: new TextStyle(color: Colors.black),
              onChanged: (text) {
                _want.content = text;
                _onChanged(_want);
              },
            ),
          ]),
        ));
  }
}
