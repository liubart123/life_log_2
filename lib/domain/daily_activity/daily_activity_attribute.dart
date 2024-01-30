abstract class DailyActivityAttribute {
  DailyActivityAttribute(this.key, this.label);
  DailyActivityAttribute.key(String key) : this(key, key);

  String key;
  String label;
}

class DailyActivityAttributeValue {
  DailyActivityAttributeValue(this.attribute, this.value);

  DailyActivityAttribute attribute;
  dynamic value;
}

class NumericDailyActivityAttribute extends DailyActivityAttribute {
  NumericDailyActivityAttribute(super.key, super.label);
  NumericDailyActivityAttribute.key(super.key) : super.key();
}

class StringDailyActivityAttribute extends DailyActivityAttribute {
  StringDailyActivityAttribute(super.key, super.label);
  StringDailyActivityAttribute.key(super.key) : super.key();
}

class BoolDailyActivityAttribute extends DailyActivityAttribute {
  BoolDailyActivityAttribute(super.key, super.label);
  BoolDailyActivityAttribute.key(super.key) : super.key();
}

class TimeDailyActivityAttribute extends DailyActivityAttribute {
  TimeDailyActivityAttribute(super.key, super.label);
  TimeDailyActivityAttribute.key(super.key) : super.key();
}

class DurationDailyActivityAttribute extends DailyActivityAttribute {
  DurationDailyActivityAttribute(super.key, super.label);
  DurationDailyActivityAttribute.key(super.key) : super.key();
}

class EnumDailyActivityAttribute extends DailyActivityAttribute {
  EnumDailyActivityAttribute(super.key, super.label, this.enumOptions);
  EnumDailyActivityAttribute.key(super.key, this.enumOptions) : super.key();
  List<String> enumOptions;
}
