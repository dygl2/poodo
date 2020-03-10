import 'package:flutter/material.dart';
import 'package:poodo/log/condition_log.dart';

class EditConditionDialog extends StatelessWidget {
  static displayDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Select condition'),
            children: <Widget>[
              SimpleDialogOption(
                child: Row(
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/icons/very_good.png'),
                      width: 30.0,
                    ),
                    Text(' Very Good'),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context, Condition.VERY_GOOD.index);
                },
              ),
              SimpleDialogOption(
                child: Row(
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/icons/moderately_good.png'),
                      width: 30.0,
                    ),
                    Text(' Moderately Good'),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context, Condition.MODERATELY_GOOD.index);
                },
              ),
              SimpleDialogOption(
                child: Row(
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/icons/not_very_good.png'),
                      width: 30.0,
                    ),
                    Text(' Not Very Good'),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context, Condition.NOT_VERY_GOOD.index);
                },
              ),
              SimpleDialogOption(
                child: Row(
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/icons/very_bad.png'),
                      width: 30.0,
                    ),
                    Text(' Very Bad'),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context, Condition.VERY_BAD.index);
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
