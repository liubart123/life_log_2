import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:life_log_2/my_widgets/elevation_utils.dart';
import 'package:life_log_2/my_widgets/my_constants.dart';
import 'package:life_log_2/utils/DateTimeUtils.dart';
import 'package:structures/structures.dart';

import 'my_old_widgets.dart';

const String INVALID_INPUT_ERROR_MESSAGE = 'Invalid Data';

class MyDateTimeInputField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final DateTime? initialValue;
  final Function(DateTime?)? validValueHandler;

  const MyDateTimeInputField({
    super.key,
    required this.label,
    this.initialValue,
    this.icon,
    this.validValueHandler,
  });

  @override
  Widget build(BuildContext context) {
    return MyInputField(
      label: label,
      icon: icon,
      inputHandler: specifiedInputHandler,
      textInputType: TextInputType.number,
      initialValue: initialValue == null ? null : stringifyTime(initialValue!),
    );
  }

  InputValueHandleResult specifiedInputHandler(
      TextEditingController _controller, String previousValue) {
    InputValueHandleResult result = InputValueHandleResult();
    String resultedValue =
        _controller.text.trim().replaceAll(RegExp(r'[^0-9:]'), '');
    if (resultedValue.length > 5) resultedValue = resultedValue.substring(0, 5);

    if (resultedValue.length == 2) {
      if (previousValue.length == 1)
        resultedValue = resultedValue + ":";
      else if (previousValue.length == 3)
        resultedValue = resultedValue.substring(0, 1);
    }

    if (resultedValue != _controller.text) _controller.text = resultedValue;

    if (resultedValue.length != 0 &&
        !resultedValue.contains(RegExp(r'^([01]\d|[2][0-4]):([0-5]\d)$')))
      result.errorMessage = INVALID_INPUT_ERROR_MESSAGE;

    if (result.errorMessage == null && validValueHandler != null) {
      validValueHandler!(
        resultedValue == "" ? null : parseTime(resultedValue),
      );
    }

    return result;
  }
}

class MyDurationInputField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Duration? initialValue;
  final Function(Duration?)? validValueHandler;

  const MyDurationInputField({
    super.key,
    required this.label,
    this.initialValue,
    this.icon,
    this.validValueHandler,
  });

  @override
  Widget build(BuildContext context) {
    return MyInputField(
      label: label,
      icon: icon,
      inputHandler: specifiedInputHandler,
      textInputType: TextInputType.number,
      initialValue:
          initialValue == null ? null : stringifyDuration(initialValue!),
    );
  }

  InputValueHandleResult specifiedInputHandler(
      TextEditingController _controller, String previousValue) {
    InputValueHandleResult result = InputValueHandleResult();
    String resultedValue =
        _controller.text.trim().replaceAll(RegExp(r'[^0-9:]'), '');
    if (resultedValue.length > 5) resultedValue = resultedValue.substring(0, 5);

    if (resultedValue.length == 2) {
      if (previousValue.length == 1)
        resultedValue = resultedValue + ":";
      else if (previousValue.length == 3)
        resultedValue = resultedValue.substring(0, 1);
    }

    if (resultedValue != _controller.text) _controller.text = resultedValue;

    if (resultedValue.length != 0 &&
        !resultedValue.contains(RegExp(r'^(\d{2}):([0-5]\d)$')))
      result.errorMessage = INVALID_INPUT_ERROR_MESSAGE;

    if (result.errorMessage == null && validValueHandler != null) {
      validValueHandler!(
        resultedValue == "" ? null : parseDuration(resultedValue),
      );
    }

    return result;
  }
}

class MyInputField extends StatefulWidget {
  final IconData? icon;
  final String label;
  final String? errorMessage;
  final TextInputType textInputType;
  final InputValueHandleResult Function(TextEditingController, String)?
      inputHandler;
  final String? initialValue;

  const MyInputField({
    super.key,
    required this.label,
    this.icon,
    this.errorMessage,
    this.inputHandler,
    this.initialValue,
    this.textInputType = TextInputType.text,
  });

  @override
  State<MyInputField> createState() {
    print('textField createState');
    return _MyInputFieldState();
  }
}

class _MyInputFieldState extends State<MyInputField> {
  final _controller = TextEditingController();
  InputValueHandleResult? inputHandleResult;
  String _previousValue = "";

  _MyInputFieldState();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) _controller.text = widget.initialValue!;
    _previousValue = _controller.text;

    _controller.addListener(() {
      setState(() {
        if (widget.inputHandler != null)
          inputHandleResult = widget.inputHandler!(_controller, _previousValue);
        _previousValue = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('textField build');
    return TextField(
      textInputAction: TextInputAction.next,
      keyboardType: widget.textInputType,
      controller: _controller,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        errorText: widget.errorMessage ?? inputHandleResult?.errorMessage,
        labelText: widget.label,
        //decoration
        prefixIcon: widget.icon != null
            ? Icon(
                widget.icon,
                size: 25,
                color: Theme.of(context).colorScheme.outline,
              )
            : null,
        prefixIconConstraints: BoxConstraints.tight(Size.square(48)),
        filled: false,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 3,
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error.withOpacity(0.5),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
        floatingLabelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.7),
            ),
      ),
    );
  }
}

class InputValueHandleResult {
  String? errorMessage;
}
