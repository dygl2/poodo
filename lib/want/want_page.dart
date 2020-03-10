import 'package:flutter/material.dart';
import 'package:poodo/db_provider.dart';
import 'package:poodo/want/edit_want_page.dart';
import 'package:poodo/want/want.dart';

class WantPage extends StatefulWidget {
  @override
  _WantPageState createState() => _WantPageState();
}

class _WantPageState extends State<WantPage> {
  final String type = "want";
  List<Want> _listWant = [];
  int _index = 0;
  int _maxNumber = 1;

  void _init() async {
    _listWant = await DbProvider().getWantAll();
    if (_listWant.length > 0) {
      _maxNumber = _listWant[_listWant.length - 1].number + 1;
    }
    await _updateNumber();

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
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) async {
                  Want want;
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    want = _listWant.removeAt(oldIndex);

                    _listWant.insert(newIndex, want);
                  });
                  if (want != null) {
                    await DbProvider().delete('want', oldIndex);
                    await DbProvider().insert('want', want);
                    await _updateNumber();
                  }
                },
                children: List.generate(
                  _listWant.length,
                  (index) {
                    return Card(
                      key: Key(_listWant[index].id.toString()),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Text(_listWant[index].title),
                            ),
                            Container(
                              width: 40,
                              child: InkWell(
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.redAccent,
                                ),
                                onTap: () async {
                                  setState(() {
                                    DbProvider()
                                        .delete(type, _listWant[index].id);
                                    _listWant.removeAt(index);
                                  });

                                  await _updateNumber();
                                },
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            _edit(_listWant[index], index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }

  void _add() {
    setState(() {
      _index = _listWant.length;
      int id = DateTime.now().millisecondsSinceEpoch;
      Want want = new Want(id: id, title: "", number: _maxNumber, content: "");
      DbProvider().insert(type, want);
      _listWant.add(want);
      _maxNumber++;

      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return new EditWantPage(want, _onChanged);
      }));
    });
  }

  void _edit(Want want, int index) {
    setState(() {
      _index = index;

      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return new EditWantPage(want, _onChanged);
      }));
    });
  }

  void _onChanged(Want want) {
    setState(() {
      _listWant[_index].id = want.id;
      _listWant[_index].title = want.title;
      _listWant[_index].number = want.number;
      _listWant[_index].content = want.content;

      DbProvider().update(type, want, _listWant[_index].id);
    });
  }

  Future<void> _updateNumber() async {
    int num = 1;
    _listWant.forEach((Want p) {
      p.number = num;
      DbProvider().update('want', p, p.id);
      num++;
    });
  }
}
