import 'package:flutter/material.dart';
import 'package:poodo/data.dart';

class ConditionLog extends Data {
  int id;
  String date;
  int category;
  int condition;

  ConditionLog({this.id, this.date, this.category, this.condition});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'category': category,
      'condition': condition,
    };
  }

  static dynamic setConditionLog(int cnd) {
    Image ret;

    switch (Condition.values[cnd]) {
      case Condition.VERY_BAD:
        ret = new Image.asset('assets/icons/very_bad.png');
        break;
      case Condition.NOT_VERY_GOOD:
        ret = new Image.asset('assets/icons/not_very_good.png');
        break;
      case Condition.MODERATELY_GOOD:
        ret = new Image.asset('assets/icons/moderately_good.png');
        break;
      case Condition.VERY_GOOD:
        ret = new Image.asset('assets/icons/very_good.png');
        break;
    }

    return ret;
  }

  static int updateConditionRank(int morning, int noon, int night) {
    return 100 - morning * 10 - noon * 10 - night * 10;
  }
}

enum ConditionCategory {
  MORNING,
  NOON,
  NIGHT,
}

enum Condition {
  VERY_GOOD,
  MODERATELY_GOOD,
  NOT_VERY_GOOD,
  VERY_BAD,
}
