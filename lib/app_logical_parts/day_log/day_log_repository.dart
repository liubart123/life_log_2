import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_log_2/app_logical_parts/day_log/day_log_model.dart';
import 'package:life_log_2/utils/DateTimeUtils.dart';
import 'package:life_log_2/utils/StringFormatters.dart';

/// Provides high-level functions to interact with DayLogs from database
class DayLogRepository {
  DayLogRepository();

  /// Returns limited amount of days from DB orderd by date. If maxDateFilter is
  /// set then returns only days earlier then given date.
  Future<DayLogPageResult> getAllDayLogs({DateTime? maxDateFilter}) async {
    throw UnimplementedError();
  }

  /// Returns dayLog with given id
  Future<DayLog?> getDayLog(int id) async {
    throw UnimplementedError();
  }

  /// Overrides all fields of DayLog in DB to those from [dayLogToUpload].
  /// [dayLogToUpload]'s ID is used to find appropriate record in DB
  Future<void> updateDayLog(DayLog dayLogToUpload) async {
    throw UnimplementedError();
  }
}

class DayLogPageResult {
  DayLogPageResult({
    required this.dayLogList,
    required this.noMorePagesToLoad,
  });
  List<DayLog> dayLogList;
  bool noMorePagesToLoad;
}
