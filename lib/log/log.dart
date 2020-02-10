import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poodo/log/aggregate.dart';
import 'package:poodo/log/condition_log.dart';
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

  static Future<Aggregate> getAggregate(DateTime targetDate) async {
    Aggregate result = new Aggregate(targetDate);
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
            targetDate.year) {
          result.yearlyTotal += item.cost;

          // calculate yearly category aggregation
          switch (item.category) {
            case 'food':
              result.listCategoryYearlyTotal[0] += item.cost;
              break;
            case 'dailyuse':
              result.listCategoryYearlyTotal[1] += item.cost;
              break;
            case 'healthcare':
              result.listCategoryYearlyTotal[2] += item.cost;
              break;
            case 'luxury':
              result.listCategoryYearlyTotal[3] += item.cost;
              break;
          }

          if (DateTime.fromMillisecondsSinceEpoch(item.date).month ==
              targetDate.month) {
            result.mothlyTotal += item.cost;

            // calculate monthly category aggregation
            switch (item.category) {
              case 'food':
                result.listCateogryMonthlyTotal[0] += item.cost;
                break;
              case 'dailyuse':
                result.listCateogryMonthlyTotal[1] += item.cost;
                break;
              case 'healthcare':
                result.listCateogryMonthlyTotal[2] += item.cost;
                break;
              case 'luxury':
                result.listCateogryMonthlyTotal[3] += item.cost;
                break;
            }

            if (DateTime.fromMillisecondsSinceEpoch(item.date).day ==
                targetDate.day) {
              result.dayTotal += item.cost;
            }
          }
        }
      }
    }

    // weekly total cost
    for (var ls in _lists) {
      for (var item in ls) {
        Duration tmp = DateTime.fromMillisecondsSinceEpoch(item.date)
            .difference(targetDate);
        if (tmp.inDays > 0) {
          print(tmp.inDays);
        }
        if ((DateTime.fromMillisecondsSinceEpoch(item.date)
                        .difference(targetDate)
                        .inDays) <=
                    0 &&
                DateTime.fromMillisecondsSinceEpoch(item.date)
                        .difference(targetDate)
                        .inDays
                        .abs() <=
                    targetDate.weekday - 1 ||
            (DateTime.fromMillisecondsSinceEpoch(item.date)
                        .difference(targetDate)
                        .inDays) >
                    0 &&
                DateTime.fromMillisecondsSinceEpoch(item.date)
                        .difference(targetDate)
                        .inDays <=
                    (6 - targetDate.weekday)) {
          result.weeklyTotal += item.cost;
        }
      }
    }

    return result;
  }

  static Future<void> addLog(
      BuildContext context, String category, DateTime date) async {
    final _dialog = new EditCostDialog(category);
    final result = await _dialog.displayDialog(context);
    final _now = DateTime.now().millisecondsSinceEpoch;

    if (result != null && result.toString().isNotEmpty) {
      switch (category) {
        case 'food':
          var tmp = new Food(
              id: _now,
              category: 'food',
              date: date.millisecondsSinceEpoch,
              cost: int.parse(result));
          DbProvider().insert(category, tmp);
          break;
        case 'dailyuse':
          var tmp = new DailyUse(
              id: _now,
              category: 'dailyuse',
              date: date.millisecondsSinceEpoch,
              cost: int.parse(result));
          DbProvider().insert(category, tmp);
          break;
        case 'healthcare':
          var tmp = new HealthCare(
              id: _now,
              category: 'healthcare',
              date: date.millisecondsSinceEpoch,
              cost: int.parse(result));
          DbProvider().insert(category, tmp);
          break;
        case 'luxury':
          var tmp = new Luxury(
              id: _now,
              category: 'luxury',
              date: date.millisecondsSinceEpoch,
              cost: int.parse(result));
          DbProvider().insert(category, tmp);
          break;
      }
    }
  }

  static Future<void> updateLog(
      BuildContext context, String category, int index) async {
    final _dialog = new EditCostDialog(category);
    final result = await _dialog.displayDialog(context);

    if (result.toString().isNotEmpty) {
      List<Expense> org = await DbProvider().getExpense(category, index);

      switch (category) {
        case 'food':
          var tmp = new Food(
              id: org[0].id,
              category: 'food',
              date: org[0].date,
              cost: int.parse(result));
          DbProvider().update(category, tmp, index);
          break;
        case 'dailyuse':
          var tmp = new DailyUse(
              id: org[0].id,
              category: 'dailyuse',
              date: org[0].date,
              cost: int.parse(result));
          DbProvider().update(category, tmp, index);
          break;
        case 'healthcare':
          var tmp = new HealthCare(
              id: org[0].id,
              category: 'healthcare',
              date: org[0].date,
              cost: int.parse(result));
          DbProvider().update(category, tmp, index);
          break;
        case 'luxury':
          var tmp = new Luxury(
              id: org[0].id,
              category: 'luxury',
              date: org[0].date,
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

  static Future<List<ConditionLog>> getConditionLog(
      DateTime date, ConditionCategory category) async {
    return DbProvider().getConditionLog(date, category);
  }
}
