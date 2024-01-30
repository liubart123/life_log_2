class DailyActivityCategory {
  DailyActivityCategory(this.key, this.label);
  DailyActivityCategory.key(String key) : this(key, key);

  String key;
  String label;
}

class DailyActivitySubCategory {
  DailyActivitySubCategory(this.key, this.label);
  DailyActivitySubCategory.key(String key) : this(key, key);
  String key;
  String label;
}
