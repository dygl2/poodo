import 'package:flutter/material.dart';
import 'package:poodo/log/aggregate.dart';

class AggregateDialog extends StatelessWidget {
  static String _title = 'Aggregate';

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
                  'Yearly Total (' + DateTime.now().year.toString() + ')\n',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.end,
                ),
                Text(
                  aggregate.yearlyTotal.toString(),
                  style: TextStyle(fontSize: 24.0),
                  textAlign: TextAlign.end,
                ),
                Text(
                  '\nMonthly Total (' + DateTime.now().month.toString() + ')\n',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.end,
                ),
                Text(
                  aggregate.mothlyTotal.toString(),
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
