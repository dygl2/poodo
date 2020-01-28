import 'package:poodo/log/expense.dart';

class DailyUse extends Expense {
  DailyUse({int id, String category, DateTime date, int cost})
      : super(id, category, date, cost);
}
