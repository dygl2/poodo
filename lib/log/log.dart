import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poodo/log/aggregate.dart';
import 'package:poodo/log/confirm_dialog.dart';
import 'package:poodo/log/expense.dart';
import 'package:poodo/db_provider.dart';
import 'package:poodo/log/edit_cost_dialog.dart';
import 'package:poodo/log/food.dart';
import 'package:poodo/log/dailyuse.dart';
import 'package:poodo/log/healthcare.dart';
import 'package:poodo/log/luxury.dart';

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

  static Future<Aggregate> getAggregate() async {
    Aggregate result = new Aggregate();
    List<Expense> _listFood = await DbProvider().getExpenseAll('food');
    List<Expense> _listDailyuse = await DbProvider().getExpenseAll('dailyuse');
    List<Expense> _listHealthcare =
        await DbProvider().getExpenseAll('healthcare');
    List<Expense> _listLuxury = await DbProvider().getExpenseAll('luxury');

    List<List<Expense>> _lists = [];
    _lists.add(_listFood);
    _lists.add(_listDailyuse);
    _lists.add(_listHealthcare);
    _lists.add(_listLuxury);

    for (var ls in _lists) {
      for (var item in ls) {
        if (DateTime.fromMillisecondsSinceEpoch(item.date).year ==
            DateTime.now().year) {
          result.yearlyTotal += item.cost;
          if (DateTime.fromMillisecondsSinceEpoch(item.date).month ==
              DateTime.now().month) {
            result.mothlyTotal += item.cost;
            if ((DateTime.fromMillisecondsSinceEpoch(item.date).day -
                            DateTime.now().day)
                        .abs() <
                    7 &&
                DateTime.fromMillisecondsSinceEpoch(item.date).weekday -
                        DateTime.now().weekday >
                    0) {
              result.weeklyTotal += item.cost;
              if (item.date == DateTime.now().millisecondsSinceEpoch) {
                result.dayTotal += item.cost;
              }
            }
          }
        }
      }
    }
    return result;
  }

  static Future<void> addLog(
      BuildContext context, String category, DateTime date) async {
    final _dialog = new EditCostDialog(category);
    final result = await _dialog.displayDialog(context);

    if (result.toString().isNotEmpty) {
      switch (category) {
        case 'food':
          var tmp = new Food(
              id: DateTime.now().millisecondsSinceEpoch,
              category: 'food',
              date: date.millisecondsSinceEpoch,
              cost: int.parse(result));
          DbProvider().insert(category, tmp);
          break;
        case 'dailyuse':
          var tmp = new DailyUse(
              id: DateTime.now().millisecondsSinceEpoch,
              category: 'dailyuse',
              date: date.millisecondsSinceEpoch,
              cost: int.parse(result));
          DbProvider().insert(category, tmp);
          break;
        case 'healthcare':
          var tmp = new HealthCare(
              id: DateTime.now().millisecondsSinceEpoch,
              category: 'healthcare',
              date: date.millisecondsSinceEpoch,
              cost: int.parse(result));
          DbProvider().insert(category, tmp);
          break;
        case 'luxury':
          var tmp = new Luxury(
              id: DateTime.now().millisecondsSinceEpoch,
              category: 'luxury',
              date: date.millisecondsSinceEpoch,
              cost: int.parse(result));
          DbProvider().insert(category, tmp);
          break;
      }
    }
  }

  static Future<void> updateLog(
      BuildContext context, String category, int index, DateTime date) async {
    final _dialog = new EditCostDialog(category);
    final result = await _dialog.displayDialog(context);

    if (result.toString().isNotEmpty) {
      switch (category) {
        case 'food':
          var tmp = new Food(
              id: DateTime.now().millisecondsSinceEpoch,
              category: 'food',
              date: date.millisecondsSinceEpoch,
              cost: int.parse(result));
          DbProvider().update(category, tmp, index);
          break;
        case 'dailyuse':
          var tmp = new DailyUse(
              id: DateTime.now().millisecondsSinceEpoch,
              category: 'dailyuse',
              date: date.millisecondsSinceEpoch,
              cost: int.parse(result));
          DbProvider().update(category, tmp, index);
          break;
        case 'healthcare':
          var tmp = new HealthCare(
              id: DateTime.now().millisecondsSinceEpoch,
              category: 'healthcare',
              date: date.millisecondsSinceEpoch,
              cost: int.parse(result));
          DbProvider().update(category, tmp, index);
          break;
        case 'luxury':
          var tmp = new Luxury(
              id: DateTime.now().millisecondsSinceEpoch,
              category: 'luxury',
              date: date.millisecondsSinceEpoch,
              cost: int.parse(result));
          DbProvider().update(category, tmp, index);
          break;
      }
    }
  }

  static Future<void> deleteLog(BuildContext context, String category,
      List<Expense> list, int index) async {
    final result = await ConfirmDialog.displayDialog(context);

    if (result == true) {
      await DbProvider().delete(category, list[index].id);
    }
  }
}
