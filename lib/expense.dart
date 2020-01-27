abstract class Expense {
  String _category;
  int _cost;

  Expense(this._category, this._cost);

  String getName() {
    return this._category;
  }

  int getCost() {
    return this._cost;
  }
}
