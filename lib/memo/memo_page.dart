import 'package:flutter/material.dart';
import 'package:poodo/db_provider.dart';
import 'package:poodo/memo/edit_memo_page.dart';
import 'package:poodo/memo/memo.dart';
import 'package:poodo/memo/memo_list.dart';

class MemoPage extends StatefulWidget {
  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final String type = "memo";
  MemoList _listMemo = new MemoList([]);
  int _index = 0;

  void _init() async {
    await _listMemo.getMemoAll();

    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _add();
          },
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: ListView.builder(
                itemCount: _listMemo.length(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Text(_listMemo.reference(index).title),
                          ),
                          Container(
                            width: 40,
                            child: InkWell(
                              child: Icon(
                                Icons.remove_circle,
                                color: Colors.redAccent,
                              ),
                              onTap: () {
                                setState(() {
                                  DbProvider().delete(
                                      type, _listMemo.reference(index).id);
                                  _listMemo.delete(index);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _edit(_listMemo.reference(index), index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

  void _add() {
    setState(() {
      _index = _listMemo.length();
      _listMemo.add();
      DbProvider().insert(type, _listMemo.reference(_index));

      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return new EditMemoPage(_listMemo.reference(_index), _onChanged);
      }));
    });
  }

  void _edit(Memo memo, int index) {
    setState(() {
      _index = index;

      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return new EditMemoPage(memo, _onChanged);
      }));
    });
  }

  void _onChanged(Memo memo) {
    setState(() {
      _listMemo.update(memo, _index);
      DbProvider().update(type, memo, _listMemo.reference(_index).id);
    });
  }
}
