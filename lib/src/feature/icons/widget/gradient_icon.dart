import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

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
