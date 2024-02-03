import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:life_log_2/domain/daily_activity/daily_activity_attribute.dart';
import 'package:life_log_2/home/daily_activity_edit_bottom_sheet/daily_activity_edit_bottom_sheet_controller.dart';
import 'package:life_log_2/my_flutter_elements/my_input_widgets.dart';
import 'package:life_log_2/my_flutter_elements/my_widgets.dart';

Widget createTagsForBoolAttributeValues(List<DailyActivityAttributeValue> attributeValues) {
  return Container(
    // color: Get.theme.colorScheme.surfaceVariant,
    child: Wrap(
      alignment: WrapAlignment.start,
      spacing: 4, // gap between adjacent chips
      runSpacing: 4, // gap between lines
      children: [
        ...attributeValues.map((attributeValue) {
          final attribute = attributeValue.attribute as BoolDailyActivityAttribute;
          final tagIsChecked = attributeValue.value as bool;
          return MyTagButton(
            label: attribute.label,
            buttonColor: Color.lerp(
              Get.theme.colorScheme.secondaryContainer,
              Get.theme.colorScheme.surface,
              tagIsChecked ? 0 : 0.7,
            )!,
            checked: tagIsChecked,
            callback: () {
              attributeValue.value = !tagIsChecked;
              Get.find<DailyActivityEditBottomSheetController>().update();
            },
          );
        }),
      ],
    ),
  );
}

Widget createWidgetForAttributeValue(DailyActivityAttributeValue attributeValue) {
  if (attributeValue.attribute is StringDailyActivityAttribute) {
    return _stringAttribute(attributeValue);
  } else if (attributeValue.attribute is NumericDailyActivityAttribute) {
    return _numericAttrbiute(attributeValue);
  } else if (attributeValue.attribute is BoolDailyActivityAttribute) {
    throw UnimplementedError();
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
  return MyTimeInputField.withCallback(
    value,
    label: attribute.label,
    onValueSubmitFromUserInput: (newValue) {
      attributeValue.value = newValue;
      Get.find<DailyActivityEditBottomSheetController>().update();
    },
  );
}

Widget _durationAttribute(
  DailyActivityAttributeValue attributeValue,
) {
  final attribute = attributeValue.attribute as DurationDailyActivityAttribute;
  final value = attributeValue.value as Duration;
  return MyDurationInputField.withCallback(
    value,
    label: attribute.label,
    onValueSubmitFromUserInput: (newValue) {
      attributeValue.value = newValue;
      Get.find<DailyActivityEditBottomSheetController>().update();
    },
  );
}

Widget _enumAttribute(
  DailyActivityAttributeValue attributeValue,
) {
  final attribute = attributeValue.attribute as EnumDailyActivityAttribute;
  final enumOptions = (attributeValue.attribute as EnumDailyActivityAttribute).enumOptions;
  final value = attributeValue.value as String;
  return Container(
    // color: Get.theme.colorScheme.surfaceVariant,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(flex: 1, child: Divider()),
            // Flexible(flex: 0, fit: FlexFit.loose, child: SizedBox(width: 10, child: Divider())),
            Flexible(
              flex: 0,
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  attribute.label,
                  style: Get.textTheme.labelSmall!.copyWith(
                    color: Get.theme.colorScheme.outline,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Flexible(flex: 1, child: Divider()),
          ],
        ),
        Gap(4),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 4, // gap between adjacent chips
          runSpacing: 4, // gap between lines
          children: [
            ...enumOptions.map(
              (enumOption) => MyRadioButton(
                label: enumOption,
                buttonColor: Color.lerp(
                  Get.theme.colorScheme.secondaryContainer,
                  Get.theme.colorScheme.surface,
                  enumOption == value ? 0 : 0.5,
                )!,
                checked: enumOption == value,
                callback: () {
                  attributeValue.value = enumOption;
                  Get.find<DailyActivityEditBottomSheetController>().update();
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
