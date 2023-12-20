import 'package:life_log_2/domain/daily_activity/daily_activity_attribute.dart';

class DailyActivityCategory {
  DailyActivityCategory(this.name, this.subCategories);

  String name;
  List<DailyActivitySubCategory> subCategories;
}

class DailyActivitySubCategory {
  DailyActivitySubCategory(this.name, this.attributes, this.defaultDuration);
  String name;
  List<DailyActivityAttribute> attributes;
  Duration defaultDuration;
}
