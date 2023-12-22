// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

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

  @override
  dynamic getValue() {
    return value;
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

  @override
  dynamic getValue() {
    return value;
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

  @override
  dynamic getValue() {
    return value;
  }
}

class EnumDailyActivityAttribute extends DailyActivityAttribute {
  EnumDailyActivityAttribute(
    super.name,
    super.label,
    this.enumOptions,
    String stringValue,
  ) {
    setValue(stringValue);
  }
  EnumDailyActivityAttribute.clone(EnumDailyActivityAttribute source)
      : this(
          source.name,
          source.label,
          List.from(
            source.enumOptions.map(
              EnumDailyActivityAttributeOption.clone,
            ),
          ),
          source.value.key,
        );

  List<EnumDailyActivityAttributeOption> enumOptions;
  late EnumDailyActivityAttributeOption value;

  void setValue(String newValueKey) {
    value = enumOptions.firstWhere((x) => x.key == newValueKey);
  }

  @override
  EnumDailyActivityAttribute clone() {
    return EnumDailyActivityAttribute.clone(this);
  }

  @override
  dynamic getValue() {
    return value;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnumDailyActivityAttributeOption &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;
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

  @override
  dynamic getValue() {
    return value;
  }
}
