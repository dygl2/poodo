import 'package:flutter/material.dart';
import 'package:poodo/log/aggregate.dart';
import 'package:poodo/log/monthly_cost.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AggregateDialog extends StatelessWidget {
  static String _title = 'Aggregate';
  static List<List<MonthlyCost>> _monthlyCost = List.generate(
      10,
      (_) => new List.generate(12,
          (i) => (new MonthlyCost((i + 1).toString(), 0, charts.Color.black))));

  static var series = [
    new charts.Series(
      id: 'month',
      domainFn: (MonthlyCost monthlyCost, _) => monthlyCost.month,
      measureFn: (MonthlyCost monthlyCost, _) => monthlyCost.cost,
      colorFn: (MonthlyCost monthlyCost, _) => monthlyCost.color,
      data: _monthlyCost[0],
    ),
  ];

  static var chart = new charts.BarChart(
    series,
    animate: true,
  );

  static displayDialog(BuildContext context, Aggregate aggregate) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(_title),
            content: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Yearly Total (' +
                      aggregate.targetDate.year.toString() +
                      ')\n',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.end,
                ),
                Text(
                  aggregate.yearlyTotal.toString(),
                  style: TextStyle(fontSize: 24.0),
                  textAlign: TextAlign.end,
                ),
                Text(
                  '\nMonthly Total (' +
                      aggregate.targetDate.month.toString() +
                      ')\n',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.end,
                ),
                Text(
                  aggregate.monthlyTotal.toString(),
                  style: TextStyle(fontSize: 24.0),
                  textAlign: TextAlign.end,
                ),
                Text(
                  '\nWeekly Total\n',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.end,
                ),
                Text(
                  aggregate.weeklyTotal.toString(),
                  style: TextStyle(fontSize: 24.0),
                  textAlign: TextAlign.end,
                ),
                SizedBox(child: chart, height: 200.0),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
