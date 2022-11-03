import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../common/util/screen_util.dart';

/// {@template icons_screen}
/// IconsScreen widget
/// {@endtemplate}
class IconsScreen extends StatelessWidget {
  /// {@macro icons_screen}
  const IconsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Icons')),
        body: SafeArea(
          child: Center(
            child: GridView.extent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 1,
              padding: ScreenUtil.centerPadding(context),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const <Widget>[
                Tooltip(
                  message: 'HeartbeatIcon',
                  child: HeartbeatIcon(
                    duration: Duration(milliseconds: 650),
                    icon: Icon(
                      FontAwesomeIcons.heartPulse,
                      color: Colors.red,
                      size: 64,
                    ),
                  ),
                ),
                Tooltip(
                  message: 'GradientIcon',
                  child: GradientIcon(
                    duration: Duration(milliseconds: 2400),
                    icon: FlutterLogo(
                      size: 64,
                    ),
                  ),
                ),
                Tooltip(
                  message: 'RadialProgressIndicator',
                  child: RadialProgressIndicator(
                    size: 64,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

// --- HeartbeatIcon --- //

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

// --- GradientIcon --- //

/// {@template gradient_icon}
/// GradientIcon widget
/// {@endtemplate}
class GradientIcon extends StatefulWidget {
  /// {@macro gradient_icon}
  const GradientIcon({
    required this.icon,
    this.duration = const Duration(milliseconds: 2400),
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget icon;

  /// The duration of the animation.
  final Duration duration;

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
        TweenSequenceItem<double>(tween: Tween<double>(begin: 0, end: 1), weight: 1),
        TweenSequenceItem<double>(tween: Tween<double>(begin: 1, end: 0), weight: 1),
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
                opacity: Tween<double>(begin: .15, end: .4).animate(
                  ReverseAnimation(_reversed).drive(CurveTween(curve: Curves.easeInOut)),
                ),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1.2, end: 1.5).animate(
                    CurvedAnimation(parent: _reversed, curve: Curves.easeInOut),
                  ),
                  child: ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2, tileMode: TileMode.decal),
                    child: AnimatedBuilder(
                      animation: _gradient,
                      builder: (context, child) => ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (rect) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          tileMode: TileMode.decal,
                          transform: GradientRotation(_gradient.value * 2 * math.pi),
                          stops: const <double>[.5, .5],
                          colors: const <Color>[Colors.deepOrange, Colors.lightBlue],
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

// --- RadialProgressIndicator --- //

/// {@template radial_progress_indicator}
/// RadialProgressIndicator widget
/// {@endtemplate}
class RadialProgressIndicator extends StatefulWidget {
  /// {@macro radial_progress_indicator}
  const RadialProgressIndicator({
    this.size = 64,
    this.child,
    Key? key,
  }) : super(key: key);

  /// The size of the progress indicator
  final double size;

  /// The child widget
  final Widget? child;

  @override
  State<RadialProgressIndicator> createState() => _RadialProgressIndicatorState();
}

class _RadialProgressIndicatorState extends State<RadialProgressIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _sweepController;
  late final Animation<double> _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _curvedAnimation = CurvedAnimation(
      parent: _sweepController,
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox.square(
          dimension: widget.size,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _RadialProgressIndicatorPainter(
                animation: _curvedAnimation,
                color: Theme.of(context).indicatorColor,
              ),
              child: Center(
                child: widget.child,
              ),
            ),
          ),
        ),
      );
}

class _RadialProgressIndicatorPainter extends CustomPainter {
  _RadialProgressIndicatorPainter({
    required Animation<double> animation,
    Color color = Colors.blue,
  })  : _animation = animation,
        _arcPaint = Paint()
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..color = color,
        super(repaint: animation);

  final Animation<double> _animation;
  final Paint _arcPaint;

  @override
  void paint(Canvas canvas, Size size) {
    _arcPaint.strokeWidth = size.shortestSide / 8;
    final progress = _animation.value;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: size.shortestSide / 2 - _arcPaint.strokeWidth / 2,
    );
    final rotate = math.pow(progress, 2) * math.pi * 2;
    final sweep = math.sin(progress * math.pi) * 3 + math.pi * .25;

    canvas.drawArc(rect, rotate, sweep, false, _arcPaint);
  }

  @override
  bool shouldRepaint(covariant _RadialProgressIndicatorPainter oldDelegate) =>
      _animation.value != oldDelegate._animation.value;

  @override
  bool shouldRebuildSemantics(covariant _RadialProgressIndicatorPainter oldDelegate) => false;
}
