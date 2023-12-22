abstract class DailyActivityAttribute {
  DailyActivityAttribute(this.name, this.label);

  String name;
  String label;
  DailyActivityAttribute clone();
  dynamic getValue();
}
