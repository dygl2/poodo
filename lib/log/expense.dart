import 'package:poodo/data.dart';

abstract class Expense extends Data {
  int id;
  String category;
  DateTime date;
  int cost;

  Expense(this.id, this.category, this.date, this.cost);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'date': date,
      'cost': cost,
    };
  }
}
