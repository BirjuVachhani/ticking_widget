/// Represents the mode of ticking. It can be millisecond, second, minute, or hour.
/// This is used to determine when to rebuild the widget.
/// For example, if the mode is set to [TickingMode.second], the widget will rebuild
/// every second.
/// If the mode is set to [TickingMode.minute], the widget will rebuild every minute.
/// If the mode is set to [TickingMode.hour], the widget will rebuild every hour.
/// If the mode is set to [TickingMode.millisecond], the widget will rebuild every millisecond.
/// The default mode is [TickingMode.second].
/// The mode can be changed at runtime using [TickingInterface.setMode] method.
enum TickingMode {
  /// Represents the mode when the widget should rebuild every millisecond.
  /// This is the most frequent mode and should be used with caution.
  /// This mode is not recommended for most use cases.
  millisecond,

  /// Represents the mode when the widget should rebuild every second.
  /// This is the most common mode and is the default mode.
  /// This mode is recommended for most use cases.
  /// This is useful for building stopwatches and countdowns.
  second,

  /// Represents the mode when the widget should rebuild every minute.
  /// This mode is recommended for use cases where the widget needs to be
  /// updated every minute.
  /// This is useful for building clocks and timers.
  minute,

  /// Represents the mode when the widget should rebuild every hour.
  /// This mode is recommended for use cases where the widget needs to be
  /// updated every hour.
  /// This is useful for building clocks and timers.
  hour;

  /// Returns true if the mode is [TickingMode.millisecond].
  bool get isMillisecond => this == TickingMode.millisecond;

  /// Returns true if the mode is [TickingMode.second].
  bool get isSecond => this == TickingMode.second;

  /// Returns true if the mode is [TickingMode.minute].
  bool get isMinute => this == TickingMode.minute;

  /// Returns true if the mode is [TickingMode.hour].
  bool get isHour => this == TickingMode.hour;
}
