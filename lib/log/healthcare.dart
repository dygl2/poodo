import 'package:poodo/log/expense.dart';

class HealthCare extends Expense {
  HealthCare({int id, int category, int date, int cost, String remarks})
      : super(id, category, date, cost, remarks);
}
