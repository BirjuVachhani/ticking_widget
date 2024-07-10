import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'ticking_interface.dart';
import 'ticking_mode.dart';

/// A mixin class that provides the ticking functionality to the widget.
/// This mixin class can be used with the [State] class to provide the ticking
/// functionality to the widget.
///
/// This will automatically start the ticker when the widget is initialized
/// based on the [autoStart] property.
///
/// This will automatically rebuild the widget at the given interval based on
/// the [mode] property.
///
/// To use this mixin, the [State] class must also use the [TickerProvider]
/// mixin via the [SingleTickerProviderStateMixin] or [TickerProviderStateMixin].
///
/// Note that [SingleTickingStateMixin] must be defined after [TickerProvider]
/// in the mixin list, otherwise, it will throw a compile-time error.
mixin TickingWidgetMixin<T extends StatefulWidget>
    on State<T>, TickerProvider
    implements TickingInterface {
  @override
  late Ticker ticker;

  @override
  late DateTime currentTime;

  @override
  Duration elapsed = Duration.zero;

  @override
  TickingMode mode = TickingMode.second;

  /// If true, the ticker will start automatically when the widget is initialized.
  /// If this is set to false, the ticker will not start automatically when the
  /// widget is initialized. To start the ticker, use the [startTicker] method.
  ///
  /// Alternatively to start the ticker from descendant widgets, use the
  /// [TickingInterface.startTicker] method.
  /// Example:
  /// ```dart
  /// final ticking = TickingWidget.of(context);
  /// ticking.startTicker();
  /// ```
  /// The default value is true.
  bool autoStart = true;

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
    ticker = createTicker(onTick);
    if (autoStart) ticker.start();
  }

  /// Called every time the ticker ticks. Determines when to rebuild the widget.
  void onTick(Duration elapsed) {
    this.elapsed = elapsed;
    final newTime = DateTime.now();
    // rebuild only if change is detected on given mode instead of every frame.
    switch (mode) {
      case TickingMode.millisecond
          when currentTime.millisecond != newTime.millisecond:
      case TickingMode.second when currentTime.second != newTime.second:
      case TickingMode.minute when currentTime.minute != newTime.minute:
      case TickingMode.hour when currentTime.hour != newTime.hour:
        if (mounted) setState(() => currentTime = newTime);
      default:
        // Do nothing!
        break;
    }
  }

  @override
  void startTicker() {
    elapsed = Duration.zero;
    ticker.start();
  }

  @override
  void stopTicker() => ticker.stop();

  @override
  void setMode(TickingMode mode) {
    this.mode = mode;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }
}
