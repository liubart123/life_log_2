import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_attribute.dart';
import 'package:life_log_2/home/daily_activity_edit_bottom_sheet/daily_activity_edit_bottom_sheet_controller.dart';
import 'package:life_log_2/my_flutter_elements/my_input_widgets.dart';
import 'package:life_log_2/utils/log_utils.dart';

Widget createWidgetForAttributeValue(DailyActivityAttributeValue attributeValue) {
  if (attributeValue.attribute is StringDailyActivityAttribute) {
    return _stringAttribute(attributeValue);
  } else if (attributeValue.attribute is NumericDailyActivityAttribute) {
    return _numericAttrbiute(attributeValue);
  } else if (attributeValue.attribute is BoolDailyActivityAttribute) {
    return _boolAttribute(attributeValue);
  } else if (attributeValue.attribute is TimeDailyActivityAttribute) {
    return _timeAttribute(attributeValue);
  } else if (attributeValue.attribute is DurationDailyActivityAttribute) {
    return _durationAttribute(attributeValue);
  } else if (attributeValue.attribute is EnumDailyActivityAttribute) {
    return _enumAttribute(attributeValue);
  } else {
    throw UnimplementedError();
  }
}

Widget _stringAttribute(
  DailyActivityAttributeValue attributeValue,
) {
  final attribute = attributeValue.attribute as StringDailyActivityAttribute;
  final value = attributeValue.value as String;
  return MyTextInputField(
    value,
    label: attribute.label,
    onValueSubmitFromUserInput: (newValue) {
      attributeValue.value = newValue;
      Get.find<DailyActivityEditBottomSheetController>().update();
    },
  );
}

Widget _numericAttrbiute(
  DailyActivityAttributeValue attributeValue,
) {
  final attribute = attributeValue.attribute as NumericDailyActivityAttribute;
  final value = attributeValue.value as int;
  return MyNumericField(
    value,
    label: attribute.label,
    onValueSubmitFromUserInput: (newValue) {
      attributeValue.value = newValue;
      Get.find<DailyActivityEditBottomSheetController>().update();
    },
  );
}

Widget _boolAttribute(
  DailyActivityAttributeValue attributeValue,
) {
  final attribute = attributeValue.attribute as BoolDailyActivityAttribute;
  final value = attributeValue.value as bool;
  return Container();
}

Widget _timeAttribute(
  DailyActivityAttributeValue attributeValue,
) {
  final attribute = attributeValue.attribute as TimeDailyActivityAttribute;
  final value = attributeValue.value as DateTime;
  return Container();
}

Widget _durationAttribute(
  DailyActivityAttributeValue attributeValue,
) {
  final attribute = attributeValue.attribute as DurationDailyActivityAttribute;
  final value = attributeValue.value as Duration;
  return Container();
}

Widget _enumAttribute(
  DailyActivityAttributeValue attributeValue,
) {
  final attribute = attributeValue.attribute as EnumDailyActivityAttribute;
  final value = attributeValue.value as String;
  return Container();
}
