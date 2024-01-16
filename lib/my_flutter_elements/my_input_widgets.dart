import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_log_2/utils/duration/duration_extension.dart';
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
      onSubmit: (newValue, resetValue) => onSubmit(newValue),
      inputType: TextInputType.number,
      onChangeFormatter: _createTextInputFormatterForTimeFormat(
        RegExp(r'^([2][4-9]|[3-9]|\d{2}[6-9])'),
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
  final Duration initialValue;
  final String label;
  final Function(Duration? newValue) onSubmit;

  @override
  Widget build(BuildContext context) {
    return MyRawTextInputField(
      initialValue: initialValue.toFormattedString(),
      label: label,
      onSubmit: (newString, resetValue) {
        if (newString == '') {
          onSubmit(null);
        } else if (!RegExp(r'^\d{2}:[0-5]\d$').hasMatch(newString)) {
          resetValue();
        } else {
          onSubmit(convertStringToDuration(newString));
        }
      },
      inputType: TextInputType.number,
      onChangeFormatter: _createTextInputFormatterForTimeFormat(
        RegExp(r'^\d?\d?(?<=\d{2})[6-9]\d?$'),
      ),
    );
  }
}

class MyRawTextInputField extends StatefulWidget {
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
  final Function(String newValue, Function({String? newValue}) resetValue) onSubmit;
  final TextInputFormatter? onChangeFormatter;
  final TextInputType inputType;

  @override
  State<MyRawTextInputField> createState() => _MyRawTextInputFieldState();
}

class _MyRawTextInputFieldState extends State<MyRawTextInputField> {
  late TextEditingController _controller;
  late String previousSubmittedValue = widget.initialValue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    // previousSubmittedValue = widget.initialValue;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetValue({String? newValue}) {
    if (newValue == null) {
      _controller.text = previousSubmittedValue;
    } else {
      _controller.text = newValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.next,
      keyboardType: widget.inputType,
      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      style: Get.textTheme.bodyMedium!.copyWith(
        color: Get.theme.colorScheme.onSurface,
      ),
      inputFormatters: [
        if (widget.onChangeFormatter != null) widget.onChangeFormatter!,
      ],
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
        widget.onSubmit(_controller.text, _resetValue);
        previousSubmittedValue = _controller.text;
      },
      onSubmitted: (value) {
        widget.onSubmit(value, _resetValue);
        previousSubmittedValue = _controller.text;
      },
      decoration: InputDecoration(
        errorText: widget.errorMessage,
        errorStyle: Get.textTheme.bodyMedium!.copyWith(
          color: Get.theme.colorScheme.error,
        ),
        labelText: widget.label,
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
