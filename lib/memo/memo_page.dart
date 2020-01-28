import 'package:flutter/material.dart';
import 'package:poodo/db_provider.dart';
import 'package:poodo/memo/edit_memo_page.dart';
import 'package:poodo/memo/memo.dart';

class MemoPage extends StatefulWidget {
  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final String type = "memo";
  List<Memo> _listMemo = [];
  int _index = 0;

  void _init() async {
    _listMemo = await DbProvider().getMemoAll();

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
                itemCount: _listMemo.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Text(_listMemo[index].title),
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
                                  DbProvider()
                                      .delete(type, _listMemo[index].id);
                                  _listMemo.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _edit(_listMemo[index], index);
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
      _index = _listMemo.length;
      int id = DateTime.now().millisecondsSinceEpoch;
      Memo memo = new Memo(id: id, title: "", content: "");
      DbProvider().insert(type, memo);
      _listMemo.add(memo);

      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return new EditMemoPage(memo, _onChanged);
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
      _listMemo[_index].id = memo.id;
      _listMemo[_index].title = memo.title;
      _listMemo[_index].content = memo.content;

      DbProvider().update(type, memo, _listMemo[_index].id);
    });
  }
}
