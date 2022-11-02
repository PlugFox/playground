import 'dart:math';
import 'dart:ui';

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
                GradientIcon(
                  icon: FlutterLogo(
                    size: 64,
                  ),
                  /* colors: <Color>[
                    Colors.lightBlue,
                    Colors.blue,
                    Colors.deepOrange,
                    Colors.red,
                  ], */
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

/// {@template gradient_icon}
/// GradientIcon widget
/// {@endtemplate}
class GradientIcon extends StatefulWidget {
  /// {@macro gradient_icon}
  const GradientIcon({
    required this.icon,
    this.duration = const Duration(milliseconds: 1200),
    this.colors,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget icon;

  /// The duration of the animation.
  final Duration duration;

  final List<Color>? colors;

  @override
  State<GradientIcon> createState() => _GradientIconState();
}

class _GradientIconState extends State<GradientIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _gradient, _reversed;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 0,
    )..repeat();
    _reversed = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1, end: 0),
          weight: 1,
        ),
      ],
    ).animate(_controller);
    _gradient = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void didUpdateWidget(GradientIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration == _controller.duration) return;
    _controller.duration = widget.duration;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) => Center(
        child: RepaintBoundary(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              FadeTransition(
                opacity: Tween<double>(begin: .15, end: .5).animate(
                  ReverseAnimation(_reversed).drive(CurveTween(curve: Curves.easeInOut)),
                ),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1.2, end: 1.5).animate(
                    CurvedAnimation(parent: _reversed, curve: Curves.easeInOut),
                  ),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2, tileMode: TileMode.decal),
                    child: AnimatedBuilder(
                      animation: _gradient,
                      builder: (context, child) => ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (rect) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          tileMode: TileMode.decal,
                          transform: GradientRotation(_gradient.value * 2 * pi),
                          colors: widget.colors ??
                              <Color>[
                                Colors.red,
                                Colors.orange,
                                Colors.yellow,
                                Colors.green,
                                Colors.blue,
                                Colors.indigo,
                                Colors.purple,
                              ],
                        ).createShader(rect),
                        child: widget.icon,
                      ),
                    ),
                  ),
                ),
              ),
              widget.icon,
            ],
          ),
        ),
      );
}
