import 'package:poodo/log/expense.dart';

class Food extends Expense {
  Food({int id, int category, int date, int cost, String remarks})
      : super(id, category, date, cost, remarks);
}
