# ticking_widget

A widget to build clocks, timers and everything that changes with time.

[![Pub Package](https://img.shields.io/pub/v/ticking_widget.svg)](https://pub.dev/packages/ticking_widget) [![Code Quality](https://github.com/BirjuVachhani/ticking_widget/workflows/Code%20Quality/badge.svg?branch=main)](https://github.com/BirjuVachhani/flutter_screwdriver/actions)

## Getting Started

1. Add as a dependency in your project's `pub spec.yaml`

```yaml
dependencies:
  ticking_widget: <latest_version>
```

2. Import library into your code.

```dart
import 'package:ticking_widget/ticking_widget.dart';
```

## Usage

### Using `TickingWidget`.
```dart
TickingWidget(
  builder: (context, currentTime, child) {
    // return a widget that needs to change with time.
  },
  child: Container(), // Optional: a widget that doesn't need to change with time.
)
```

#### Example: Building a Digital Clock

```dart
TickingWidget(
  mode: TickingMode.second,
  builder: (context, now, child) => Text(
    DateFormat('hh:mm:ss a').format(now),
  ),
)
```

#### Example: Building a Timer

```dart
TickingWidget(
  mode: TickingMode.second,
  builder: (context, now, child) {
    final Duration elapsed = TickingWidget.of(context).elapsed;
    return Text(
      '\${elapsed.inHours}h \${elapsed.inMinutes % 60}m \${elapsed.inSeconds % 60}s',
    );
  },
)
```

### Example: Building a Countdown

```dart
TickingWidget(
  mode: TickingMode.second,
  builder: (context, now, child) {
    final Duration remaining = const Duration(minutes: 15) -
        TickingWidget.of(context).elapsed;
    return Text(
      '\${remaining.inHours.toString().padLeft(2, '0')}:'
      '\${(remaining.inMinutes % 60).toString().padLeft(2, '0')}:'
      '\${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',
    );
  },
)
```

### Using `TickingWidgetMixin`.

If you wanna have a custom implementation of your own and don't wanna use `TickingWidget` then you can use 
`TickingWidgetMixin` to get the current time and elapsed time.

> Note: You need to use `SingleTickerProviderStateMixin` along with `TickingWidgetMixin` for the mixin to work.

```dart
class MyCustomWidget extends StatefulWidget {
  @override
  _MyCustomWidgetState createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget>
    with SingleTickerProviderStateMixin, TickingWidgetMixin {
  @override
  void initState() {
    autoStart = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Duration elapsed = this.elapsed;
    return Column(
      children: [
        const Text('Timer'),
        Text('${elapsed.inMinutes}:${elapsed.inSeconds % 60}'),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => stopTicker(),
              child: const Text('Stop'),
            ),
            ElevatedButton(
              onPressed: () => startTicker(),
              child: const Text('Start'),
            ),
          ],
        ),
      ],
    );
  }
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/BirjuVachhani/ticking_widget/issues
[docs]: https://pub.dev/documentation/ticking_widget/latest/

#### Liked this package?

Show some love and support by starring the [repository](https://github.com/birjuvachhani/ticking_widget).

Or You can

<a href="https://www.buymeacoffee.com/birjuvachhani" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-blue.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>


## License

```
Copyright (c) 2024, Birju Vachhani
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
