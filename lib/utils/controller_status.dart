/// Possible statuses for standard widget controller
enum EControllerStatus {
  /// First loading/processing for the widget. Usually there are not
  /// much useful data to display during this status.
  initializing,

  /// Some processing is happening. Some user's actions can be limited
  /// until processing is over to avoid issues.
  processing,

  /// Nothing is in process with controller. User can freely use the widget.
  idle,

  /// Error appeared, but not crucial. User isn't blocked in most of actions.
  minorError,

  /// Error appeared, and user is blocked in actions.
  /// Widget cannot function in proper way.
  majorError,
}
