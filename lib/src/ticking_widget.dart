/*
 * Copyright © 2024 Birju Vachhani. All rights reserved.
 * Use of this source code is governed by a BSD 3-Clause License that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'ticking_interface.dart';
import 'ticking_mode.dart';
import 'ticking_widget_mixin.dart';

/// A builder function type that is used to build the ticking widget.
typedef TickingWidgetBuilder = Widget Function(
    BuildContext context, DateTime currentTime, Widget? child);

/// A widget that rebuilds itself at a given interval.
/// This widget is useful for building widgets that need to be updated at a given interval.
/// For example, this widget can be used to build clocks, timers, stopwatches, and countdowns.
/// This widget can be used to build any widget that needs to be updated at a given interval.
/// Example:
/// ```dart
/// TickingWidget(
///  mode: TickingMode.second,
///  builder: (context, currentTime, child) {
///     // This widget will rebuild every second.
///     return Text(currentTime.toString());
///   },
///  ),
///  ```
class TickingWidget extends StatefulWidget {
  /// The builder function that is used to build the ticking widget.
  /// This function is called every time the widget needs to be rebuilt.
  ///
  /// The [currentTime] parameter is the current time when the widget is
  /// being rebuilt.
  ///
  /// The [child] parameter is the child widget that is passed to
  /// the [TickingWidget].
  ///
  /// If the [builder] is not provided, the [child] must be provided.
  ///
  /// If both [builder] and [child] are provided, the [builder] will be used
  /// and the [child] will be passed to the [builder] function.
  final TickingWidgetBuilder? builder;

  /// The child widget that is passed to the [TickingWidget].
  /// If the [builder] is not provided, the [child] must be provided.
  /// If both [builder] and [child] are provided, the [builder] will be used
  /// and the [child] will be passed to the [builder] function.
  final Widget? child;

  /// The mode of ticking. It can be millisecond, second, minute, or hour.
  /// This is used to determine when to rebuild the widget.
  /// For example, if the mode is set to [TickingMode.second],
  /// the widget will rebuild every second.
  final TickingMode mode;

  /// If true, the ticker will start automatically when the widget is initialized.
  /// If false, the ticker will not start automatically when the widget is initialized.
  /// The default value is true.
  /// This can be changed at runtime using [TickingInterface.startTicker] and
  /// [TickingInterface.stopTicker] methods.
  ///
  /// Any child widget of this widget can access the [TickingInterface] using
  /// [TickingWidget.of] method with appropriate context.
  final bool autoStart;

  /// Creates a new [TickingWidget].
  const TickingWidget({
    super.key,
    this.builder,
    this.child,
    required this.mode,
    this.autoStart = true,
  }) : assert(builder != null || child != null,
            'Either builder or child must be provided');

  /// Returns the [TickingInterface] of the nearest [TickingWidget] ancestor.
  /// This method can be used to access the [TickingInterface] of the nearest
  /// [TickingWidget] ancestor to control the ticking of the widget.
  /// Example:
  /// ```dart
  /// final ticking = TickingWidget.of(context);
  /// ticking.startTicker();
  /// ```
  /// This method throws an error if the [TickingInterface] is not found in the
  /// ancestor tree.
  static TickingInterface of(BuildContext context) =>
      context.findAncestorStateOfType<_TickingWidgetState>()!;

  /// Returns the [TickingInterface] of the nearest [TickingWidget] ancestor.
  /// This method can be used to access the [TickingInterface] of the nearest
  /// [TickingWidget] ancestor to control the ticking of the widget.
  /// Example:
  /// ```dart
  /// final ticking = TickingWidget.maybeOf(context);
  /// ticking?.startTicker();
  /// ```
  /// This method returns null if the [TickingInterface] is not found in the
  /// ancestor tree.
  static TickingInterface? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_TickingWidgetState>();

  @override
  State<TickingWidget> createState() => _TickingWidgetState();
}

class _TickingWidgetState extends State<TickingWidget>
    with SingleTickerProviderStateMixin, TickingWidgetMixin {
  @override
  void initState() {
    // set the autoStart and mode from the widget.
    autoStart = widget.autoStart;
    mode = widget.mode;

    // It is important to call super.initState() after setting the autoStart
    // and mode. This is because the initState method of the mixin class
    // uses these values.
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TickingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode) mode = widget.mode;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return widget.builder?.call(context, currentTime, widget.child) ??
            widget.child!;
      },
    );
  }
}
