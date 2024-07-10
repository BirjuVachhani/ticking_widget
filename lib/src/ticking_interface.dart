import 'package:flutter/scheduler.dart';

import 'ticking_mode.dart';

/// A ticking interface that provides methods to control the ticking of the widget.
abstract interface class TickingInterface {
  /// The ticker that is used to control the ticking of the widget.
  abstract Ticker ticker;

  /// The current time when the widget is being rebuilt.
  late DateTime currentTime;

  /// The mode of ticking. It can be millisecond, second, minute, or hour.
  /// This is used to determine when to rebuild the widget.
  ///
  /// For example, if the mode is set to [TickingMode.second],
  /// the widget will rebuild every second.
  abstract TickingMode mode;

  /// Duration elapsed since the ticker started.
  /// Resets to zero when ticker is started.
  abstract Duration elapsed;

  /// Starts the ticker.
  void startTicker();

  /// Stops the ticker.
  void stopTicker();

  /// Sets the mode of the ticker to the given [TickingMode].
  void setMode(TickingMode mode);
}
