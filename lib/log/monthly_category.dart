import 'package:poodo/log/log_category.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MonthlyCategory {
  LogCategory category;
  double percentage;
  int cost;
  charts.Color color;

  MonthlyCategory(this.category, this.percentage, this.cost, this.color);
}
