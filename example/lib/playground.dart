import 'package:dart_style/dart_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:ticking_widget/ticking_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Highlighter.initialize(['dart', 'yaml', 'sql']);

  final HighlighterTheme theme = await HighlighterTheme.loadLightTheme();

  runApp(MyApp(highlightTheme: theme));
}

class MyApp extends StatelessWidget {
  final HighlighterTheme highlightTheme;

  const MyApp({super.key, required this.highlightTheme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        highlightTheme: highlightTheme,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final HighlighterTheme highlightTheme;

  const MyHomePage({
    super.key,
    required this.highlightTheme,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum ExampleType { digitalClock, timer, countdown }

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  late final Highlighter highlighter = Highlighter(
    language: 'dart',
    theme: widget.highlightTheme,
  );

  @override
  Widget build(BuildContext context) {
    final ExampleItem selectedItem = examples[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Ticking Widget Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 56, 8, 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              runSpacing: 16,
              spacing: 16,
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final (index, item) in examples.indexed)
                  Builder(builder: (context) {
                    final bool selected = _selectedIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIndex = index),
                      child: FocusableActionDetector(
                        onFocusChange: (focused) {
                          if (focused) {
                            setState(() => _selectedIndex = index);
                          }
                        },
                        actions: {
                          ActivateAction: CallbackAction(
                            onInvoke: (_) =>
                                setState(() => _selectedIndex = index),
                          ),
                        },
                        mouseCursor: SystemMouseCursors.click,
                        child: AnimatedContainer(
                          width: 300,
                          height: 300,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutQuart,
                          margin: !selected
                              ? const EdgeInsets.all(2)
                              : EdgeInsets.zero,
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              border: Border.all(
                                color: selected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                if (selected)
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.2),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                              ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(32),
                                      child: DefaultTextStyle(
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.w200,
                                                fontSize: 56,
                                                fontFeatures: [
                                              const FontFeature
                                                  .tabularFigures(),
                                            ]),
                                        textAlign: TextAlign.center,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: item.builder(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 16, 16, 16),
                constraints: const BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  // color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedItem.title,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: () => Clipboard.setData(
                                ClipboardData(text: selectedItem.code)),
                            icon: const Icon(Icons.copy, size: 18),
                            label: const Text('Copy'),
                          ),
                        ],
                      ),
                    ),
                    // Divider(
                    //   height: 1,
                    //   thickness: 1,
                    //   color: Theme.of(context).colorScheme.secondary,
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text.rich(
                        highlighter.highlight(DartFormatter()
                            .formatStatement('${selectedItem.code};')
                            .replaceAll(RegExp(r';$'), '')),
                        style: GoogleFonts.sourceCodePro(
                          height: 1.5,
                          fontFeatures: [
                            const FontFeature.tabularFigures(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleItem {
  final String title;
  final ExampleType type;
  final String code;
  final WidgetBuilder builder;

  const ExampleItem({
    required this.title,
    required this.type,
    required this.code,
    required this.builder,
  });
}

const List<ExampleItem> examples = [
  ExampleItem(
    title: 'Digital Clock',
    type: ExampleType.digitalClock,
    code: digitalClockCode,
    builder: buildDigitalClock,
  ),
  ExampleItem(
    title: 'Timer',
    type: ExampleType.timer,
    code: timerCode,
    builder: buildTimer,
  ),
  ExampleItem(
    title: 'Countdown',
    type: ExampleType.countdown,
    code: countdownCode,
    builder: buildCountdown,
  ),
];

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
      Duration elapsed = TickingWidget.of(context).elapsed;
      final Duration remaining = elapsed > const Duration(minutes: 15)
          ? Duration.zero
          : const Duration(minutes: 15) - elapsed;
      return Text(
        '${remaining.inHours.toString().padLeft(2, '0')}:'
        '${(remaining.inMinutes % 60).toString().padLeft(2, '0')}:'
        '${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',
      );
    },
  );
}

const String digitalClockCode = '''
TickingWidget(
  mode: TickingMode.second,
  builder: (context, now, child) => Text(
    DateFormat('hh:mm:ss a').format(now),
  ),
)''';

const String timerCode = '''
TickingWidget(
  mode: TickingMode.second,
  builder: (context, now, child) {
    final Duration elapsed = TickingWidget.of(context).elapsed;
    return Text(
      '\${elapsed.inHours}h \${elapsed.inMinutes % 60}m \${elapsed.inSeconds % 60}s',
    );
  },
)''';

const String countdownCode = '''
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
)''';
