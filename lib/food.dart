import 'package:poodo/expense.dart';

class Food extends Expense {
  Food({int id, String category, DateTime date, int cost})
      : super(id, category, date, cost);
}
