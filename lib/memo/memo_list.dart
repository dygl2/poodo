import 'package:poodo/db_provider.dart';
import 'package:poodo/memo/memo.dart';

class MemoList {
  List<Memo> list = [];

  MemoList(list);

  void getMemoAll() {
    DbProvider().getMemoAll();
  }

  int length() {
    return list.length;
  }

  void add() {
    int id = DateTime.now().millisecondsSinceEpoch;
    Memo memo = new Memo(id: id, content: "", title: "");
    list.add(memo);
  }

  void addList(List<Memo> addedList) {
    list.addAll(addedList);
  }

  Memo reference(int index) {
    return new Memo(
        id: list[index].id,
        content: list[index].content,
        title: list[index].title);
  }

  List<Memo> referenceList() {
    return list;
  }

  void delete(int index) {
    list.removeAt(index);
  }

  void update(Memo newData, int index) {
    list[index].id = newData.id;
    list[index].content = newData.content;
    list[index].title = newData.title;
  }
}
