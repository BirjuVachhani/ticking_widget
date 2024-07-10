import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticking_widget/ticking_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Ticking Widget Examples'),
      ),
      body: Center(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: [
            buildCard(
              title: 'Digital Clock',
              child: buildDigitalClock(context),
            ),
            buildCard(
              title: 'Timer',
              child: buildTimer(context),
            ),
            buildCard(
              title: 'Countdown',
              child: buildCountdown(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard({required String title, required Widget child}) {
    return Builder(builder: (context) {
      return Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: DefaultTextStyle(
                      style: DefaultTextStyle.of(context).style.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w200,
                          fontSize: 56,
                          fontFeatures: [
                            const FontFeature.tabularFigures(),
                          ]),
                      textAlign: TextAlign.center,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

Widget buildDigitalClock(BuildContext context) {
  return TickingWidget(
    mode: TickingMode.second,
    builder: (context, now, child) => Text(
      DateFormat('hh:mm:ss a').format(now),
    ),
  );
}

Widget buildTimer(BuildContext context) {
  return TickingWidget(
    mode: TickingMode.second,
    builder: (context, now, child) {
      final Duration elapsed = TickingWidget.of(context).elapsed;
      return Text(
        '${elapsed.inHours}h ${(elapsed.inMinutes % 60)}m ${(elapsed.inSeconds % 60)}s',
      );
    },
  );
}

Widget buildCountdown(BuildContext context) {
  return TickingWidget(
    mode: TickingMode.second,
    builder: (context, now, child) {
      final Duration elapsed =
          const Duration(minutes: 15) - TickingWidget.of(context).elapsed;
      return Text(
        '${elapsed.inHours.toString().padLeft(2, '0')}:'
        '${(elapsed.inMinutes % 60).toString().padLeft(2, '0')}:'
        '${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
      );
    },
  );
}
