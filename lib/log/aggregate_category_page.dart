import 'package:flutter/material.dart';
import 'package:poodo/log/aggregate.dart';
import 'package:poodo/log/log_category.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:poodo/log/monthly_category.dart';
import 'package:poodo/log/yearly_category.dart';

class AggreagateCategoryPage extends StatefulWidget {
  Aggregate _aggregate;

  AggreagateCategoryPage(this._aggregate);

  @override
  _AggregateCategoryPageState createState() =>
      _AggregateCategoryPageState(this._aggregate);
}

class _AggregateCategoryPageState extends State<AggreagateCategoryPage> {
  Aggregate _aggregate;
  static List<MonthlyCategory> _monthlyCategory = [
    new MonthlyCategory(
        LogCategory.food, 25.0, 0, charts.MaterialPalette.lime.shadeDefault),
    new MonthlyCategory(LogCategory.dailyuse, 25.0, 0,
        charts.MaterialPalette.cyan.shadeDefault),
    new MonthlyCategory(LogCategory.healthcare, 25.0, 0,
        charts.MaterialPalette.teal.shadeDefault),
    new MonthlyCategory(LogCategory.luxury, 25.0, 0,
        charts.MaterialPalette.deepOrange.shadeDefault)
  ]..length = LogCategory.values.length;

  static List<YearlyCategory> _yearlyCategory = [
    new YearlyCategory(
        LogCategory.food, 25.0, 0, charts.MaterialPalette.lime.shadeDefault),
    new YearlyCategory(LogCategory.dailyuse, 25.0, 0,
        charts.MaterialPalette.cyan.shadeDefault),
    new YearlyCategory(LogCategory.healthcare, 25.0, 0,
        charts.MaterialPalette.teal.shadeDefault),
    new YearlyCategory(LogCategory.luxury, 25.0, 0,
        charts.MaterialPalette.deepOrange.shadeDefault)
  ]..length = LogCategory.values.length;

  _AggregateCategoryPageState(this._aggregate);

  void _init() async {
    setState(() {
      for (int i = 0; i < LogCategory.values.length; i++) {
        _monthlyCategory[i].cost = _aggregate.listCateogryMonthlyTotal[i];
        _monthlyCategory[i].percentage =
            (_aggregate.listCateogryMonthlyTotal[i] /
                _aggregate.mothlyTotal *
                100.0);

        _yearlyCategory[i].cost = _aggregate.listCategoryYearlyTotal[i];
        _yearlyCategory[i].percentage = (_aggregate.listCategoryYearlyTotal[i] /
            _aggregate.yearlyTotal *
            100.0);
      }
    });
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static var monthlySeries = [
    new charts.Series(
      id: 'monthly_category',
      domainFn: (MonthlyCategory monthlyCategory, _) =>
          monthlyCategory.category.toString().split('.')[1],
      measureFn: (MonthlyCategory monthlyCategory, _) =>
          monthlyCategory.percentage,
      colorFn: (MonthlyCategory monthlyCategory, _) => monthlyCategory.color,
      labelAccessorFn: (MonthlyCategory row, _) =>
          '${row.cost}\n(${double.parse(row.percentage.toStringAsFixed(1))}%)',
      data: _monthlyCategory,
    ),
  ];

  static var monthlyChart = new charts.PieChart(
    monthlySeries,
    animate: true,
    behaviors: [
      new charts.DatumLegend(position: charts.BehaviorPosition.bottom)
    ],
    defaultRenderer: new charts.ArcRendererConfig(
        //arcWidth: 60,
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.auto)
        ]),
  );

  static var yearlySeries = [
    new charts.Series(
      id: 'yearly_category',
      domainFn: (YearlyCategory yearlyCategory, _) =>
          yearlyCategory.category.toString().split('.')[1],
      measureFn: (YearlyCategory yearlyCategory, _) =>
          yearlyCategory.percentage,
      colorFn: (YearlyCategory yearlyCategory, _) => yearlyCategory.color,
      labelAccessorFn: (YearlyCategory row, _) =>
          '${row.cost}\n(${double.parse(row.percentage.toStringAsFixed(1))}%)',
      data: _yearlyCategory,
    ),
  ];

  static var yearlyChart = new charts.PieChart(
    yearlySeries,
    animate: true,
    behaviors: [
      new charts.DatumLegend(position: charts.BehaviorPosition.bottom)
    ],
    defaultRenderer: new charts.ArcRendererConfig(
        //arcWidth: 60,
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.auto)
        ]),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aggregate category'),
      ),
      body: Column(
        children: <Widget>[
          Text(
            '\nThis Month Total (' +
                _aggregate.targetDate.month.toString() +
                ')\n',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
          Text(
            _aggregate.mothlyTotal.toString(),
            style: TextStyle(fontSize: 24.0),
            textAlign: TextAlign.end,
          ),
          SizedBox(child: monthlyChart, height: 200.0),
          Text(
            '\nThis Year Total (' +
                _aggregate.targetDate.year.toString() +
                ')\n',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
          Text(
            _aggregate.yearlyTotal.toString(),
            style: TextStyle(fontSize: 24.0),
            textAlign: TextAlign.end,
          ),
          SizedBox(child: yearlyChart, height: 200.0),
        ],
      ),
    );
  }
}
