import 'package:poodo/data.dart';

abstract class Expense extends Data {
  int id;
  int category;
  int date;
  int cost;
  String remarks;

  Expense(this.id, this.category, this.date, this.cost, this.remarks);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'date': date,
      'cost': cost,
      'remarks': remarks,
    };
  }
}
