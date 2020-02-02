class Aggregate {
  DateTime targetDate;
  int dayTotal = 0;
  int yearlyTotal = 0;
  int mothlyTotal = 0;
  int weeklyTotal = 0;

  Aggregate(DateTime date) {
    targetDate = date;
    dayTotal = 0;
    yearlyTotal = 0;
    mothlyTotal = 0;
    weeklyTotal = 0;
  }
}
