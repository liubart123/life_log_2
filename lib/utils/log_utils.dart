import 'dart:developer' as developer;

/// Levels mean importance of logged message, the higher - the less important.
///
/// controllerX: 1st level - important rare actions of controllers:
/// initialization, slow operations. 2nd level - for other logs
///
/// widgetX: logs for lifecycle of widget. 1 - tabs/screen widgets
/// and higher in hierarchy. 2 - Intermediate widgets or not important
/// logs from tabs/screens. They still can consume resource in case of
/// often rebuildings. 3 - All small widgets with small and specific task.
///
/// inputX: logs for user's input. 1 - important rare input,
/// that can cause calling other logic, like scrolling to the end of list,
/// to load new page. 2 - all other input, like input field value change.
///
/// trace: anything that isn't important enough to care about choosing
/// correct log category and level.
class MyLogger {
  static void debug(String message) {
    developer.log('message');
  }

  static void _print(String color, String message, int tabsBefore) {
    developer.log('${''.padRight(tabsBefore * 2)}\x1B${color}m$message\x1B[0m');
  }

  static void error(String message) {
    _print('[38;5;202', message, 0);
  }

  static void warning(String message) {
    _print('[38;5;208', message, 0);
  }

  static void controller1(String message) {
    _print('[38;5;82', message, 1);
  }

  static void controller2(String message) {
    _print('[38;5;76', message, 2);
  }

  static void input1(String message) {
    _print('[38;5;44', message, 2);
  }

  static void input2(String message) {
    _print('[38;5;73', message, 3);
  }

  static void widget1(String message) {
    _print('[38;5;218', message, 1);
  }

  static void widget2(String message) {
    _print('[38;5;181', message, 2);
  }

  static void widget3(String message) {
    _print('[38;5;96', message, 3);
  }

  static void trace(String message) {
    _print('[38;5;8', message, 3);
  }

  static void testColors() {
    error('error');
    warning('warning');
    controller1('controller1');
    controller2('controller2');
    widget1('widget1');
    widget2('widget2');
    widget3('widget3');
    input1('input1');
    input2('input2');
    trace('trace');
  }
}
