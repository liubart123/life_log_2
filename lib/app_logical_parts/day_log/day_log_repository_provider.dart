import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_log_2/app_logical_parts/day_log/DayLogDataProvider.dart';
import 'package:life_log_2/app_logical_parts/day_log/DayLogRepository.dart';
import 'package:life_log_2/utils/StringFormatters.dart';
import 'package:structures/structures.dart';

class DayLogRepositoryProvider extends StatelessWidget {
  final Widget child;
  const DayLogRepositoryProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DayLogRepository(DayLogDataProvider()),
      child: child,
    );
  }
}
