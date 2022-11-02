import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// {@template highlight_icons_screen}
/// HighlightIconsScreen widget
/// {@endtemplate}
class HighlightIconsScreen extends StatelessWidget {
  /// {@macro highlight_icons_screen}
  const HighlightIconsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Highlight Icons')),
        body: SafeArea(
          child: Center(
            child: GridView.extent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 1,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const <Widget>[
                HeartbeatIcon(
                  icon: Icon(
                    FontAwesomeIcons.heartPulse,
                    color: Colors.red,
                    size: 64,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

/// {@template heartbeat_icon}
/// HeartbeatIcon widget
/// {@endtemplate}
class HeartbeatIcon extends StatefulWidget {
  /// {@macro heartbeat_icon}
  const HeartbeatIcon({
    required this.icon,
    this.duration = const Duration(milliseconds: 650),
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget icon;

  /// The duration of the animation.
  final Duration duration;

  @override
  State<HeartbeatIcon> createState() => _HeartbeatIconState();
}

class _HeartbeatIconState extends State<HeartbeatIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _heartbeat1, _heartbeat2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration, value: 0)..repeat();
    _heartbeat1 = CurvedAnimation(parent: _controller, curve: const Interval(0, .75, curve: Curves.easeInOut));
    _heartbeat2 = CurvedAnimation(parent: _controller, curve: const Interval(.5, 1, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(HeartbeatIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration == _controller.duration) return;
    _controller.duration = widget.duration;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: RepaintBoundary(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              FadeTransition(
                opacity: ReverseAnimation(_heartbeat1),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1, end: 1.75).animate(_heartbeat1),
                  child: widget.icon,
                ),
              ),
              FadeTransition(
                opacity: Tween<double>(begin: 0, end: .75).animate(ReverseAnimation(_heartbeat2)),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1, end: 1.5).animate(_heartbeat2),
                  child: widget.icon,
                ),
              ),
              widget.icon,
            ],
          ),
        ),
      );
}
