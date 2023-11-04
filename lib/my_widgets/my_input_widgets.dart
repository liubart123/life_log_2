import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:life_log_2/my_widgets/elevation_utils.dart';
import 'package:life_log_2/my_widgets/my_constants.dart';
import 'package:structures/structures.dart';

import 'my_old_widgets.dart';

const String INVALID_INPUT_ERROR_MESSAGE = 'Invalid Data';

class MyTextField extends StatefulWidget {
  final IconData? icon;
  final String label;
  final String? externalError;
  const MyTextField({
    super.key,
    required this.label,
    this.icon,
    this.externalError,
  });

  @override
  State<MyTextField> createState() {
    print('textField createState');
    return _MyTextFieldState(timeInputHandler, externalError);
  }

  String? timeInputHandler(
      TextEditingController _controller, String previousValue) {
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

    if (resultedValue.length != 5 && resultedValue.length != 0)
      return INVALID_INPUT_ERROR_MESSAGE;
    if (resultedValue.length != 0 &&
        !resultedValue.contains(RegExp(r'^([01]\d|[2][0-4]):([0-5]\d)$')))
      return INVALID_INPUT_ERROR_MESSAGE;

    return null;
  }
}

class _MyTextFieldState extends State<MyTextField> {
  final _controller = TextEditingController();
  final String? Function(TextEditingController, String) inputHandler;
  final String? externalErrorMessage;
  String? internalErrorMessage;
  String previousValue = "";

  _MyTextFieldState(this.inputHandler, this.externalErrorMessage);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        internalErrorMessage = inputHandler(_controller, previousValue);
        previousValue = _controller.text;
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
      keyboardType: TextInputType.number,
      controller: _controller,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
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
        labelText: widget.label,
        labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
        floatingLabelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.7),
            ),
        errorText: externalErrorMessage ?? internalErrorMessage,
      ),
    );
  }
}
