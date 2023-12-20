import 'package:life_log_2/domain/daily_activity/daily_activity_attribute.dart';

class IntDailyActivityAttribute extends DailyActivityAttribute {
  IntDailyActivityAttribute(
    super.name,
    super.label,
    this.value,
  );
  IntDailyActivityAttribute.clone(IntDailyActivityAttribute source)
      : this(
          source.name,
          source.label,
          source.value,
        );
  int value;
  @override
  IntDailyActivityAttribute clone() {
    return IntDailyActivityAttribute.clone(this);
  }
}

class DoubleDailyActivityAttribute extends DailyActivityAttribute {
  DoubleDailyActivityAttribute(
    super.name,
    super.label,
    this.value,
  );
  DoubleDailyActivityAttribute.clone(DoubleDailyActivityAttribute source)
      : this(
          source.name,
          source.label,
          source.value,
        );
  double value;
  @override
  DoubleDailyActivityAttribute clone() {
    return DoubleDailyActivityAttribute.clone(this);
  }
}

class DurationDailyActivityAttribute extends DailyActivityAttribute {
  DurationDailyActivityAttribute(
    super.name,
    super.label,
    this.value,
  );
  DurationDailyActivityAttribute.clone(DurationDailyActivityAttribute source)
      : this(source.name, source.label, source.value);
  Duration value;
  @override
  DurationDailyActivityAttribute clone() {
    return DurationDailyActivityAttribute.clone(this);
  }
}

class EnumDailyActivityAttribute extends DailyActivityAttribute {
  EnumDailyActivityAttribute(
    super.name,
    super.label,
    this.enumValueLabelPairs,
    String stringValue,
  ) {
    setValue(stringValue);
  }
  EnumDailyActivityAttribute.clone(EnumDailyActivityAttribute source)
      : this(
          source.name,
          source.label,
          List.from(
            source.enumValueLabelPairs.map(
              EnumDailyActivityAttributeOption.clone,
            ),
          ),
          source.value.key,
        );

  List<EnumDailyActivityAttributeOption> enumValueLabelPairs;
  late EnumDailyActivityAttributeOption value;

  void setValue(String newValueKey) {
    value = enumValueLabelPairs.firstWhere((x) => x.key == newValueKey);
  }

  @override
  EnumDailyActivityAttribute clone() {
    return EnumDailyActivityAttribute.clone(this);
  }
}

class EnumDailyActivityAttributeOption {
  EnumDailyActivityAttributeOption(this.key, this.label);
  EnumDailyActivityAttributeOption.clone(
    EnumDailyActivityAttributeOption source,
  ) : this(
          source.key,
          source.label,
        );
  String key;
  String label;
}

class TagDailyActivityAttribute extends DailyActivityAttribute {
  TagDailyActivityAttribute(
    super.name,
    super.label, {
    required this.value,
  });
  TagDailyActivityAttribute.clone(TagDailyActivityAttribute source)
      : this(
          source.name,
          source.label,
          value: source.value,
        );
  bool value;

  @override
  TagDailyActivityAttribute clone() {
    return TagDailyActivityAttribute.clone(this);
  }
}
