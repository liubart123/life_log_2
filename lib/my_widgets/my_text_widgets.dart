import 'dart:math';

import 'package:flutter/material.dart';
import 'package:life_log_2/my_widgets/elevation_utils.dart';
import 'package:life_log_2/my_widgets/my_constants.dart';
import 'package:structures/structures.dart';

import 'my_old_widgets.dart';

class MyTitleMedium extends StatelessWidget {
  final String title;
  const MyTitleMedium(
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}
