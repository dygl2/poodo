import 'package:poodo/log/log_category.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class YearlyCategory {
  LogCategory category;
  double percentage;
  int cost;
  charts.Color color;

  YearlyCategory(this.category, this.percentage, this.cost, this.color);
}
