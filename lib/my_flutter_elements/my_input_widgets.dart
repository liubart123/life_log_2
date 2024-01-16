import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_log_2/utils/log_utils.dart';

TextInputFormatter _createTextInputFormatterForTimeFormat(RegExp regexpForInvalidFormat) {
  return TextInputFormatter.withFunction((oldValue, newValue) {
    var resultedSelectionStart = newValue.selection.start;

    var processedString = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (regexpForInvalidFormat.hasMatch(processedString)) {
      return oldValue;
    }
    if (processedString.length >= 2) {
      if (processedString.length == 2 && oldValue.text.length == 3) {
        processedString = processedString.substring(0, 1);
      } else {
        processedString = '${processedString.substring(0, 2)}:${processedString.substring(2)}';
      }
    }
    if (processedString.length > 5) {
      processedString = processedString.substring(0, 5);
    }

    if (processedString.length == 3 && (oldValue.text.length == 1) || oldValue.text.length == 2) {
      resultedSelectionStart++;
    }
    MyLogger.input2('resulted value:$processedString');
    return TextEditingValue(
      selection: TextSelection.fromPosition(
        TextPosition(
          offset: min(resultedSelectionStart, processedString.length),
        ),
      ),
      text: processedString,
    );
  });
}

class MyTimeInputField extends StatelessWidget {
  const MyTimeInputField({
    required this.initialValue,
    required this.label,
    required this.onSubmit,
    super.key,
  });
  final String initialValue;
  final String label;
  final Function(String newValue) onSubmit;

  @override
  Widget build(BuildContext context) {
    return MyRawTextInputField(
      initialValue: initialValue,
      label: label,
      onSubmit: onSubmit,
      inputType: TextInputType.number,
      onChangeFormatter: _createTextInputFormatterForTimeFormat(
        RegExp(r'^\d?\d?(?<=\d{2})[6-9]\d?$'),
      ),
    );
  }
}

class MyIntervalInputField extends StatelessWidget {
  const MyIntervalInputField({
    required this.initialValue,
    required this.label,
    required this.onSubmit,
    super.key,
  });
  final String initialValue;
  final String label;
  final Function(String newValue) onSubmit;

  @override
  Widget build(BuildContext context) {
    return MyRawTextInputField(
      initialValue: initialValue,
      label: label,
      onSubmit: onSubmit,
      inputType: TextInputType.number,
      onChangeFormatter: _createTextInputFormatterForTimeFormat(
        RegExp(r'^([2][4-9]|[3-9]|\d{2}[6-9])'),
      ),
    );
  }
}

class MyRawTextInputField extends StatelessWidget {
  const MyRawTextInputField({
    required this.initialValue,
    required this.label,
    required this.onSubmit,
    this.errorMessage,
    this.onChangeFormatter,
    this.inputType = TextInputType.text,
    super.key,
  });
  final String initialValue;
  final String label;
  final String? errorMessage;
  final Function(String newValue) onSubmit;
  final TextInputFormatter? onChangeFormatter;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.next,
      keyboardType: inputType,
      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      style: Get.textTheme.bodyMedium!.copyWith(
        color: Get.theme.colorScheme.onSurface,
      ),
      inputFormatters: [
        if (onChangeFormatter != null) onChangeFormatter!,
      ],
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onSubmitted: onSubmit,
      decoration: InputDecoration(
        errorText: errorMessage,
        errorStyle: Get.textTheme.bodyMedium!.copyWith(
          color: Get.theme.colorScheme.error,
        ),
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.all(12),
        labelStyle: Get.textTheme.bodyMedium!.copyWith(
          color: Get.theme.colorScheme.outline,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            width: 3,
            color: Get.theme.colorScheme.surfaceVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1,
            color: Get.theme.colorScheme.secondaryContainer,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            width: 1,
            color: Get.theme.colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 2,
            color: Get.theme.colorScheme.error,
          ),
        ),
      ),
    );
  }
}
