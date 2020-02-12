class Aggregate {
  DateTime targetDate;
  int dayTotal = 0;
  int yearlyTotal = 0;
  int monthlyTotal = 0;
  int weeklyTotal = 0;
  List<int> listCateogryMonthlyTotal = []..length = 4;
  List<int> listCategoryYearlyTotal = []..length = 4;

  Aggregate(DateTime date) {
    targetDate = date;
    dayTotal = 0;
    yearlyTotal = 0;
    monthlyTotal = 0;
    weeklyTotal = 0;
    listCateogryMonthlyTotal = [0, 0, 0, 0];
    listCategoryYearlyTotal = [0, 0, 0, 0];
  }
}
