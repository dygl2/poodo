import 'package:charts_flutter/flutter.dart' as charts;

class MonthlyCost {
  final String month;
  final int cost;
  final charts.Color color;

  MonthlyCost(this.month, this.cost, this.color);
}
