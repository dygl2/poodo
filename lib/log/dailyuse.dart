import 'package:poodo/log/expense.dart';

class DailyUse extends Expense {
  DailyUse({int id, int category, int date, int cost, String remarks})
      : super(id, category, date, cost, remarks);
}
