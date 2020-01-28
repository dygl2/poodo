import 'package:intl/intl.dart';
import 'package:poodo/log/expense.dart';
import 'package:poodo/db_provider.dart';

class Log {
  static DateFormat _format = DateFormat('yyyy-MM-dd');

  static Future<List<Expense>> getLogAtDay(
      String category, DateTime date) async {
    DateTime start = DateTime.parse(_format.format(date));
    DateTime end = start.add(new Duration(days: 1));

    List<Expense> list = await DbProvider().getExpenseInPeriod(
        category, start.millisecondsSinceEpoch, end.millisecondsSinceEpoch);

    return list;
  }
}
