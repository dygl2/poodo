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
