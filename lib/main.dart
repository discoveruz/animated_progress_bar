import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ProgressbarIndicator(
                  value: value,
                  max: 100,
                  color: Colors.red.shade300,
                  backgroundColor: Colors.grey.shade200,
                  height: 10,
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              value += 10;
            });
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
  }
}

class ProgressbarIndicator extends StatefulWidget {
  const ProgressbarIndicator({
    Key? key,
    this.value = 0,
    this.max = 100,
    this.backgroundColor,
    this.color,
    this.height = 4.0,
  }) : super(key: key);

  final int value;
  final int max;

  final Color? backgroundColor;
  final Color? color;

  final double height;

  @override
  State<ProgressbarIndicator> createState() => _ProgressbarIndicatorState();
}

class _ProgressbarIndicatorState extends State<ProgressbarIndicator>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;
  double _currentBegin = 0;
  double _currentEnd = 0;

  final Duration animatedDuration = const Duration(milliseconds: 300);

  @override
  void initState() {
    _controller = AnimationController(duration: animatedDuration, vsync: this);
    _animation = Tween<double>(begin: _currentBegin, end: _currentEnd)
        .animate(_controller);
    triggerAnimation();
    super.initState();
  }

  @override
  void didUpdateWidget(ProgressbarIndicator old) {
    triggerAnimation();
    super.didUpdateWidget(old);
  }

  void triggerAnimation() {
    setState(() {
      _currentBegin = _animation.value;

      if (widget.value == 0 || widget.max == 0) {
        _currentEnd = 0;
      } else {
        _currentEnd = widget.value / widget.max;
      }

      _animation = Tween<double>(begin: _currentBegin, end: _currentEnd)
          .animate(_controller);
    });
    _controller.reset();
    _controller.duration = animatedDuration;
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedProgressBar(
        animation: _animation,
        widget: widget,
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimatedProgressBar extends AnimatedWidget {
  AnimatedProgressBar({
    Key? key,
    required Animation<double> animation,
    required this.widget,
  }) : super(key: key, listenable: animation);

  final ProgressbarIndicator widget;

  final BorderRadiusGeometry _borderRadius = BorderRadius.circular(100);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    Color progressColor = widget.color ?? Theme.of(context).primaryColor;

    List<Widget> progressWidgets = [];
    Widget progressWidget = Container(
      decoration: BoxDecoration(
        color: progressColor,
        borderRadius: _borderRadius,
      ),
    );
    progressWidgets.add(progressWidget);

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey.shade400,
        borderRadius: _borderRadius,
      ),
      child: Flex(
        direction: Axis.horizontal,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Expanded(
            flex: (animation.value * 100).toInt(),
            child: Stack(
              children: progressWidgets,
            ),
          ),
          Expanded(
            flex: 100 - (animation.value * 100).toInt(),
            child: const SizedBox(),
          )
        ],
      ),
    );
  }
}
