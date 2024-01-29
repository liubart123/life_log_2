import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_log_2/utils/datetime/datetime_extension.dart';
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
  final DateTime? initialValue;
  final String label;
  final Function(DateTime? newValue) onSubmit;

  @override
  Widget build(BuildContext context) {
    return MyRawTextInputField(
      initialValue: initialValue?.toTimeString() ?? '',
      label: label,
      onSubmit: (newString, resetValue) {
        if (newString == '') {
          onSubmit(null);
        } else if (!RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$').hasMatch(newString)) {
          resetValue();
        } else {
          onSubmit(convertStringToDateTime(newString));
        }
      },
      inputType: TextInputType.number,
      onChangeFormatter: _createTextInputFormatterForTimeFormat(
        RegExp(r'^([2][4-9]|[3-9]|\d{2}[6-9])'),
      ),
    );
  }
}

class MyIntervalInputField2 extends StatelessWidget {
  const MyIntervalInputField2({
    required this.initialValue,
    required this.label,
    required this.onSubmit,
    super.key,
  });
  final Duration? initialValue;
  final String label;
  final Function(Duration? newValue) onSubmit;

  @override
  Widget build(BuildContext context) {
    return MyRawTextInputField(
      initialValue: initialValue?.toFormattedString() ?? '',
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

class MyDurationInputField2 extends StatefulWidget {
  const MyDurationInputField2({
    required this.rxValue,
    required this.label,
    super.key,
  });
  final Rx<Duration> rxValue;
  final String label;

  @override
  State<MyDurationInputField2> createState() => _MyDurationInputField2State();
}

class _MyDurationInputField2State extends State<MyDurationInputField2> {
  late TextEditingController _controller;
  late String previousSubmittedTextValue;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    MyLogger.controller1('$runtimeType initState');
    final initialTextValue = widget.rxValue.value.toFormattedString();
    _controller = TextEditingController(text: initialTextValue);
    previousSubmittedTextValue = initialTextValue;
    _focusNode = FocusNode();
    ever(
      widget.rxValue,
      (_) {
        _updateFieldTextOnRxUpdate();
      },
    );
  }

  @override
  void dispose() {
    MyLogger.controller1('$runtimeType dispose');
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateFieldTextOnRxUpdate() {
    if (_controller.text != widget.rxValue.value.toFormattedString()) {
      MyLogger.controller2('$runtimeType setting field`s value which was changed outside');
      _controller.value = _controller.value.copyWith(
        text: widget.rxValue.value.toFormattedString(),
      );
    }
  }

  /// Format text value in field so it corresponds with time format like hh:mm
  TextInputFormatter _createInputFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      var resultedSelectionStart = newValue.selection.start;

      var processedString = newValue.text.replaceAll(RegExp(r'\D'), '');
      if (RegExp(r'^\d?\d?(?<=\d{2})[6-9]\d?$').hasMatch(processedString)) {
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

  void _trySubmitCurrentFieldValue() {
    MyLogger.controller2('$runtimeType _trySubmitCurrentFieldValue');
    final newString = _controller.value.text;
    if (newString == '') {
      _resetFieldValue();
    } else if (!RegExp(r'^\d{2}:[0-5]\d$').hasMatch(newString)) {
      _resetFieldValue();
    } else {
      MyLogger.controller2('$runtimeType submitting value');
      widget.rxValue.value = convertStringToDuration(newString);
      previousSubmittedTextValue = newString;
    }
  }

  void _resetFieldValue() {
    MyLogger.controller2('$runtimeType _resetValue');
    _controller.value = _controller.value.copyWith(text: widget.rxValue.value.toFormattedString());
    previousSubmittedTextValue = _controller.value.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      controller: _controller,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      style: Get.textTheme.bodyMedium!.copyWith(
        color: Get.theme.colorScheme.onSurface,
      ),
      inputFormatters: [
        _createInputFormatter(),
      ],
      onTapOutside: (event) {
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
          _trySubmitCurrentFieldValue();
        }
      },
      onSubmitted: (value) {
        _trySubmitCurrentFieldValue();
      },
      decoration: createDecorationForField(label: widget.label),
    );
  }
}

InputDecoration createDecorationForField({required String label}) {
  return InputDecoration(
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
  );
}

class MyDurationInputField extends StatefulWidget {
  const MyDurationInputField({
    required this.label,
    required this.onInitState,
    required this.onValueSubmitFromUserInput,
    required this.initialValue,
    this.alwaysSetFieldValueToInitialValue = false,
    super.key,
  });

  MyDurationInputField.withRx(
    Rx<Duration> rxDuration, {
    required String label,
    Key? key,
  }) : this(
          label: label,
          onInitState: (onValueChangedFromOutside) {
            ever(rxDuration, (_) {
              MyLogger.debug('Rx for inputFIeld was changed');
              onValueChangedFromOutside(rxDuration.value);
            });
          },
          onValueSubmitFromUserInput: (newValue) {
            rxDuration.value = newValue;
          },
          initialValue: rxDuration.value,
          key: key,
        );

  MyDurationInputField.withCallback(
    Duration newValue, {
    required String label,
    required Function(Duration newValue) onValueSubmitFromUserInput,
    Key? key,
  }) : this(
          label: label,
          onInitState: (_) {},
          onValueSubmitFromUserInput: onValueSubmitFromUserInput,
          initialValue: newValue,
          alwaysSetFieldValueToInitialValue: true,
          key: key,
        );
  final String label;
  final Function(Function(Duration newValue) onValueChangedFromOutside) onInitState;
  final Function(Duration newValue) onValueSubmitFromUserInput;
  final bool alwaysSetFieldValueToInitialValue;
  final Duration initialValue;

  @override
  State<MyDurationInputField> createState() => _MyDurationInputFieldState();
}

class _MyDurationInputFieldState extends State<MyDurationInputField> {
  late TextEditingController _controller;
  late String previousSubmittedTextValue;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    MyLogger.controller1('$runtimeType initState');
    final initialTextValue = widget.initialValue.toFormattedString();
    _controller = TextEditingController(text: initialTextValue);
    previousSubmittedTextValue = initialTextValue;
    _focusNode = FocusNode();
    widget.onInitState(_setFieldToNewValue);
  }

  @override
  void dispose() {
    MyLogger.controller1('$runtimeType dispose');
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MyDurationInputField oldWidget) {
    if (oldWidget.initialValue != widget.initialValue && widget.alwaysSetFieldValueToInitialValue) {
      _setFieldToNewValue(widget.initialValue);
    }
    super.didUpdateWidget(oldWidget);
  }

  /// Formatter for TextField to keep text in format hh:mm
  TextInputFormatter _createInputFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      var resultedSelectionStart = newValue.selection.start;

      var processedString = newValue.text.replaceAll(RegExp(r'\D'), '');
      if (RegExp(r'^\d?\d?(?<=\d{2})[6-9]\d?$').hasMatch(processedString)) {
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

  void _trySubmitCurrentFieldValue() {
    MyLogger.input2('$runtimeType _trySubmitCurrentFieldValue');
    if (!RegExp(r'^\d{2}:[0-5]\d$').hasMatch(_controller.value.text)) {
      _resetFieldValue();
    } else {
      _submitNewValueFromFieldValue();
    }
  }

  void _resetFieldValue() {
    MyLogger.controller2('$runtimeType _resetValue');
    _controller.text = previousSubmittedTextValue;
  }

  void _submitNewValueFromFieldValue() {
    MyLogger.input1('$runtimeType submitting new value from field');
    previousSubmittedTextValue = _controller.value.text;
    final newDuration = convertStringToDuration(_controller.value.text);
    widget.onValueSubmitFromUserInput(newDuration);
  }

  void _setFieldToNewValue(Duration newValue) {
    MyLogger.input1('$runtimeType setting new field`s value ${newValue.toFormattedString()}');
    _controller.text = newValue.toFormattedString();
    previousSubmittedTextValue = _controller.value.text;
  }

  @override
  Widget build(BuildContext context) {
    MyLogger.controller2('$runtimeType build');
    return TextField(
      focusNode: _focusNode,
      controller: _controller,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      style: Get.textTheme.bodyMedium!.copyWith(
        color: Get.theme.colorScheme.onSurface,
      ),
      inputFormatters: [
        _createInputFormatter(),
      ],
      onTapOutside: (event) {
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
          _trySubmitCurrentFieldValue();
        }
      },
      onSubmitted: (value) {
        _trySubmitCurrentFieldValue();
      },
      decoration: createDecorationForField(label: widget.label),
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
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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
  void didUpdateWidget(covariant MyRawTextInputField oldWidget) {
    MyLogger.controller2('$runtimeType didUpdateWidget');
    if (oldWidget.initialValue != widget.initialValue) {
      MyLogger.controller2('$runtimeType reset input value');
      _controller.text = widget.initialValue;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    MyLogger.controller2('$runtimeType build');
    return TextField(
      focusNode: _focusNode,
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
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
          widget.onSubmit(_controller.text, _resetValue);
          previousSubmittedValue = _controller.text;
        }
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
