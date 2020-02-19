import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poodo/log/aggregate.dart';
import 'package:poodo/log/condition_log.dart';
import 'package:poodo/log/confirm_dialog.dart';
import 'package:poodo/log/expense.dart';
import 'package:poodo/db_provider.dart';
import 'package:poodo/log/edit_cost_dialog.dart';
import 'package:poodo/log/log_category.dart';
import 'package:poodo/log/food.dart';
import 'package:poodo/log/dailyuse.dart';
import 'package:poodo/log/healthcare.dart';
import 'package:poodo/log/luxury.dart';

class Log {
  static DateFormat _format = DateFormat('yyyy-MM-dd', 'ja');

  static Future<List<Expense>> getLogAtDay(
      LogCategory category, DateTime date) async {
    DateTime start = DateTime.parse(_format.format(date));
    DateTime end = start.add(Duration(days: 1));

    List<Expense> list = await DbProvider().getExpenseInPeriod(
        category, start.millisecondsSinceEpoch, end.millisecondsSinceEpoch);

    return list;
  }

  static Future<Aggregate> getAggregate(DateTime targetDate) async {
    Aggregate result = new Aggregate(targetDate);
    List<Expense> _listFood =
        await DbProvider().getExpenseAll(LogCategory.food);
    List<Expense> _listDailyuse =
        await DbProvider().getExpenseAll(LogCategory.dailyuse);
    List<Expense> _listHealthcare =
        await DbProvider().getExpenseAll(LogCategory.healthcare);
    List<Expense> _listLuxury =
        await DbProvider().getExpenseAll(LogCategory.luxury);

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
          switch (LogCategory.values[item.category]) {
            case LogCategory.food:
              result.listCategoryYearlyTotal[0] += item.cost;
              break;
            case LogCategory.dailyuse:
              result.listCategoryYearlyTotal[1] += item.cost;
              break;
            case LogCategory.healthcare:
              result.listCategoryYearlyTotal[2] += item.cost;
              break;
            case LogCategory.luxury:
              result.listCategoryYearlyTotal[3] += item.cost;
              break;
          }

          if (DateTime.fromMillisecondsSinceEpoch(item.date).month ==
              targetDate.month) {
            result.monthlyTotal += item.cost;

            // calculate monthly category aggregation
            switch (LogCategory.values[item.category]) {
              case LogCategory.food:
                result.listCateogryMonthlyTotal[0] += item.cost;
                break;
              case LogCategory.dailyuse:
                result.listCateogryMonthlyTotal[1] += item.cost;
                break;
              case LogCategory.healthcare:
                result.listCateogryMonthlyTotal[2] += item.cost;
                break;
              case LogCategory.luxury:
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
      BuildContext context, LogCategory category, DateTime date) async {
    final _dialog = new EditCostDialog(
        category.toString().split('.')[1], CostRemarks(null, ""));
    final result = await _dialog.displayDialog(context);
    int _nowFromEpoch = DateTime.now().millisecondsSinceEpoch;

    if (result != null && result.toString().isNotEmpty) {
      var tmp;

      switch (LogCategory.values[category.index]) {
        case LogCategory.food:
          tmp = new Food(
              id: _nowFromEpoch,
              category: category.index,
              date: date.millisecondsSinceEpoch,
              cost: result.cost,
              remarks: result.remarks);
          break;
        case LogCategory.dailyuse:
          tmp = new DailyUse(
              id: _nowFromEpoch,
              category: category.index,
              date: date.millisecondsSinceEpoch,
              cost: result.cost,
              remarks: result.remarks);
          break;
        case LogCategory.healthcare:
          tmp = new HealthCare(
              id: _nowFromEpoch,
              category: category.index,
              date: date.millisecondsSinceEpoch,
              cost: result.cost,
              remarks: result.remarks);
          break;
        case LogCategory.luxury:
          tmp = new Luxury(
              id: _nowFromEpoch,
              category: category.index,
              date: date.millisecondsSinceEpoch,
              cost: result.cost,
              remarks: result.remarks);
          break;
      }

      DbProvider().insert(category.toString().split('.')[1], tmp);
    }
  }

  static Future<void> updateLog(BuildContext context, LogCategory category,
      int cost, String remarks, int index) async {
    final _dialog = new EditCostDialog(
        category.toString().split('.')[1], CostRemarks(cost, remarks));
    final CostRemarks result = await _dialog.displayDialog(context);

    if (result.toString().isNotEmpty) {
      List<Expense> org = await DbProvider().getExpense(category, index);
      var tmp;

      switch (LogCategory.values[category.index]) {
        case LogCategory.food:
          tmp = new Food(
              id: org[0].id,
              category: category.index,
              date: org[0].date,
              cost: result.cost,
              remarks: result.remarks);
          break;
        case LogCategory.dailyuse:
          tmp = new DailyUse(
              id: org[0].id,
              category: category.index,
              date: org[0].date,
              cost: result.cost,
              remarks: result.remarks);
          break;
        case LogCategory.healthcare:
          tmp = new HealthCare(
              id: org[0].id,
              category: category.index,
              date: org[0].date,
              cost: result.cost,
              remarks: result.remarks);
          break;
        case LogCategory.luxury:
          tmp = new Luxury(
              id: org[0].id,
              category: category.index,
              date: org[0].date,
              cost: result.cost,
              remarks: result.remarks);
          break;
      }

      DbProvider().update(category.toString().split('.')[1], tmp, index);
    }
  }

  static Future<void> deleteLog(BuildContext context, LogCategory category,
      List<Expense> list, int index) async {
    final result = await ConfirmDialog.displayDialog(context);

    if (result == true) {
      await DbProvider()
          .delete(category.toString().split('.')[1], list[index].id);
    }
  }

  static Future<List<ConditionLog>> getConditionLog(
      DateTime date, ConditionCategory category) async {
    return DbProvider().getConditionLog(date, category);
  }
}
