import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

/// {@template present_icon}
/// PresentIcon widget
/// {@endtemplate}
class PresentIcon extends StatefulWidget {
  /// {@macro present_icon}
  const PresentIcon({
    this.size = 64,
    super.key,
  });

  /// The size of the progress indicator
  final double size;

  @override
  State<PresentIcon> createState() => _PresentIconState();
}

/// State for widget PresentIcon
class _PresentIconState extends State<PresentIcon> with _OverlayCandiesMixin, SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 6000);
  late AnimationController _controller;
  late Animation<double> _turns, _push, _me, _down, _hide;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
      value: 0,
    )..repeat();
    _turns = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        // --- .06 .. .08 --- //
        TweenSequenceItem<double>(tween: Tween<double>(begin: 0, end: .06), weight: 1.5),
        TweenSequenceItem<double>(tween: Tween<double>(begin: .06, end: 0), weight: 1),
        TweenSequenceItem<double>(tween: Tween<double>(begin: 0, end: -.08), weight: 1),
        TweenSequenceItem<double>(tween: Tween<double>(begin: -.08, end: 0), weight: 1),
        // --- .1 .. .12 --- //
        TweenSequenceItem<double>(tween: Tween<double>(begin: 0, end: .1), weight: .9),
        TweenSequenceItem<double>(tween: Tween<double>(begin: .1, end: 0), weight: .8),
        TweenSequenceItem<double>(tween: Tween<double>(begin: 0, end: -.12), weight: .8),
        TweenSequenceItem<double>(tween: Tween<double>(begin: -.12, end: 0), weight: .9),
        // --- .1 .. .08 --- //
        TweenSequenceItem<double>(tween: Tween<double>(begin: 0, end: .1), weight: 1),
        TweenSequenceItem<double>(tween: Tween<double>(begin: .1, end: 0), weight: 1),
        TweenSequenceItem<double>(tween: Tween<double>(begin: 0, end: -.08), weight: 1),
        TweenSequenceItem<double>(tween: Tween<double>(begin: -.08, end: 0), weight: 1.5),
      ],
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(.25, .75, curve: Curves.easeInOut)));
    _push = CurvedAnimation(parent: _controller, curve: const Interval(.3, .5, curve: Curves.easeInOut));
    _me = CurvedAnimation(parent: _controller, curve: const Interval(.4, .6, curve: Curves.easeInOut));
    _down = CurvedAnimation(parent: _controller, curve: const Interval(.5, .7, curve: Curves.easeInOut));
    _hide =
        ReverseAnimation(CurvedAnimation(parent: _controller, curve: const Interval(.9, 1, curve: Curves.easeInOut)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  /* #endregion */

  Future<void> _onPressed() async {
    if (overlayStatus.value) return;
    try {
      show();
      _controller.reset();
      HapticFeedback.mediumImpact().ignore();
      await Future<void>.delayed(const Duration(milliseconds: 2000));
    } on Object {
      rethrow;
    } finally {
      hide();
      _controller.repeat().ignore();
    }
  }

  @override
  Widget build(BuildContext context) => Center(
        child: RepaintBoundary(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Center(
                  child: buildOverlay(
                    child: RotationTransition(
                      turns: _turns,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: overlayStatus,
                        builder: (context, status, child) => AnimatedScale(
                          duration: const Duration(milliseconds: 500),
                          scale: status ? .75 : 1,
                          child: IconButton(
                            onPressed: status ? null : _onPressed,
                            iconSize: widget.size,
                            color: Colors.pink,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints.expand(width: widget.size, height: widget.size),
                            splashRadius: widget.size * .75,
                            icon: const Icon(
                              FontAwesomeIcons.gift,
                              shadows: <Shadow>[
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset.zero,
                                  blurRadius: 2,
                                ),
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset.zero,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: _PresentIconWord(
                  text: 'PUSH',
                  size: widget.size,
                  alignment: Alignment.topCenter,
                  show: _push,
                  hide: _hide,
                ),
              ),
              Positioned.fill(
                child: _PresentIconWord(
                  text: 'ME',
                  size: widget.size,
                  alignment: Alignment.center,
                  show: _me,
                  hide: _hide,
                ),
              ),
              Positioned.fill(
                child: _PresentIconWord(
                  text: 'DOWN',
                  size: widget.size,
                  alignment: Alignment.bottomCenter,
                  show: _down,
                  hide: _hide,
                ),
              ),
            ],
          ),
        ),
      );
}

class _PresentIconWord extends StatelessWidget {
  const _PresentIconWord({
    required this.text,
    required this.size,
    required this.alignment,
    required this.show,
    required this.hide,
  });

  final double size;
  final String text;
  final Alignment alignment;
  final Animation<double> show, hide;

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: Center(
          child: SizedBox.square(
            dimension: size,
            child: ScaleTransition(
              scale: hide,
              child: FadeTransition(
                opacity: hide,
                child: AlignTransition(
                  alignment: AlignmentTween(
                    begin: Alignment.center,
                    end: alignment,
                  ).animate(show),
                  child: ScaleTransition(
                    scale: show,
                    child: FadeTransition(
                      opacity: show,
                      child: Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.coiny(
                          fontSize: size / 4,
                          fontWeight: FontWeight.bold,
                          height: 1,
                          color: Colors.white,
                          shadows: <Shadow>[
                            const BoxShadow(
                              color: Colors.black,
                              offset: Offset.zero,
                              blurRadius: 2,
                            ),
                            const BoxShadow(
                              color: Colors.black,
                              offset: Offset.zero,
                              blurRadius: 4,
                            ),
                            const BoxShadow(
                              color: Colors.black,
                              offset: Offset.zero,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

mixin _OverlayCandiesMixin on State<PresentIcon> {
  @protected
  final ValueNotifier<bool> overlayStatus = ValueNotifier<bool>(false);
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @protected
  void show() {
    hide();
    Overlay.of(context)?.insert(
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          height: widget.size * 3,
          width: widget.size * 3,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: Offset.zero,
            targetAnchor: Alignment.center,
            followerAnchor: Alignment.center,
            showWhenUnlinked: false,
            child: _CandiesOverlay(onCompleted: hide),
          ),
        ),
      ),
    );
    overlayStatus.value = _overlayEntry != null;
  }

  @protected
  void hide() {
    overlayStatus.value = false;
    if (_overlayEntry == null) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    hide();
    super.dispose();
  }

  @protected
  Widget buildOverlay({required Widget child}) => CompositedTransformTarget(
        link: _layerLink,
        child: child,
      );
}

class _CandiesOverlay extends StatefulWidget {
  const _CandiesOverlay({required this.onCompleted});

  final VoidCallback onCompleted;

  @override
  State<_CandiesOverlay> createState() => _CandiesOverlayState();
}

class _CandiesOverlayState extends State<_CandiesOverlay> with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 2000);
  static final math.Random _random = math.Random();
  static const int minCandies = 16, maxCandies = 24;
  static List<IconData> get icons => <IconData>[
        Icons.cake,
        Icons.cookie,
        FontAwesomeIcons.cookie,
        FontAwesomeIcons.candyCane,
        FontAwesomeIcons.cakeCandles,
        FontAwesomeIcons.apple,
      ];
  static _Candy _buildCandy() => _Candy(
        size: _random.nextDouble() * 16 + 8,
        color: Color.lerp(Colors.pink, Colors.purple, _random.nextDouble())!,
        rotation: _random.nextDouble() * 2 * math.pi,
        rotationSpeed: _random.nextDouble() * 2 * math.pi,
        speed: _random.nextDouble() / 2 + .5,
        direction: _random.nextDouble() * 2 * math.pi,
        icon: icons[_random.nextInt(icons.length)],
      );
  static List<_Candy> _buildCandies() => List<_Candy>.generate(
        _random.nextInt(maxCandies - minCandies) + minCandies,
        (index) => _buildCandy(),
      );

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _duration,
  )..forward();
  late final Animation<double> _wave1 = CurvedAnimation(parent: _controller, curve: const Interval(0, .5)),
      _wave2 = CurvedAnimation(parent: _controller, curve: const Interval(.25, .75)),
      _wave3 = CurvedAnimation(parent: _controller, curve: const Interval(.5, 1)),
      _percent = TweenSequence<double>(<TweenSequenceItem<double>>[
        // --- .06 .. .08 --- //
        TweenSequenceItem<double>(tween: Tween<double>(begin: 0, end: 1), weight: 1),
        TweenSequenceItem<double>(tween: Tween<double>(begin: 1, end: 1), weight: 8),
        TweenSequenceItem<double>(tween: Tween<double>(begin: 1, end: 0), weight: 1),
      ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  final List<_Candy> _candies1 = _buildCandies(), _candies2 = _buildCandies(), _candies3 = _buildCandies();

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener(_onStatusChanged);
    Timer(_duration * .25, () => HapticFeedback.selectionClick().ignore());
    Timer(_duration * .5, () => HapticFeedback.selectionClick().ignore());
    Timer(_duration * .75, () => HapticFeedback.selectionClick().ignore());
    Timer(_duration, () => HapticFeedback.selectionClick().ignore());
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) widget.onCompleted();
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_onStatusChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(
              child: Material(
                color: Colors.transparent,
                child: ScaleTransition(
                  scale: _percent,
                  child: FadeTransition(
                    opacity: _percent,
                    child: ValueListenableBuilder<double>(
                      valueListenable: _controller,
                      builder: (context, progress, _) => Text(
                        '${(progress * 100).round().toString().padLeft(2, '0')}%',
                        style: GoogleFonts.coiny(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                          color: Colors.white,
                          shadows: <Shadow>[
                            const BoxShadow(
                              color: Colors.white24,
                              offset: Offset(-2, -2),
                              blurRadius: 8,
                            ),
                            const BoxShadow(
                              color: Colors.black,
                              offset: Offset(2, 2),
                              blurRadius: 8,
                            ),
                            const BoxShadow(
                              color: Colors.black,
                              offset: Offset.zero,
                              blurRadius: 6,
                            ),
                            const BoxShadow(
                              color: Colors.black,
                              offset: Offset.zero,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Flow(
                delegate: _CandiesOverlayFlowDelegate(wave: _wave1, candies: _candies1),
                children: _candies1,
              ),
            ),
            Positioned.fill(
              child: Flow(
                delegate: _CandiesOverlayFlowDelegate(wave: _wave2, candies: _candies2),
                children: _candies2,
              ),
            ),
            Positioned.fill(
              child: Flow(
                delegate: _CandiesOverlayFlowDelegate(wave: _wave3, candies: _candies3),
                children: _candies3,
              ),
            ),
          ],
        ),
      );
}

class _Candy extends StatelessWidget {
  const _Candy({
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.speed,
    required this.direction,
    required this.color,
    required this.icon,
  });

  final double size, rotation, rotationSpeed, speed, direction;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox.square(
          dimension: size,
          child: Transform.rotate(
            angle: rotation,
            child: Icon(
              icon,
              color: color,
              size: size,
            ),
          ),
        ),
      );
}

class _CandiesOverlayFlowDelegate extends FlowDelegate {
  _CandiesOverlayFlowDelegate({required this.wave, required this.candies}) : super(repaint: wave);

  final Animation<double> wave;
  final List<_Candy> candies;

  @override
  void paintChildren(FlowPaintingContext context) {
    if (wave.value == 0 || wave.value == 1) {
      for (var i = 0; i < context.childCount; i++) {
        context.paintChild(i, opacity: 0);
      }
      return;
    }

    final size = context.size;
    final opacity = _getOpacity(wave.value);

    for (var i = 0; i < context.childCount; i++) {
      final candy = candies[i];
      final angle = i * 2 * math.pi / context.childCount,
          radius = (size.shortestSide - candy.size) / 2 * wave.value,
          x = radius * math.cos(angle) * candy.speed,
          y = radius * math.sin(angle) * candy.speed;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(x, y, 0),
        opacity: opacity,
      );
    }
  }

  static double _getOpacity(double progress) {
    if (progress < .25) return progress * 4;
    if (progress < .75) return 1;
    return (1 - progress) * 4;
  }

  @override
  bool shouldRepaint(covariant _CandiesOverlayFlowDelegate oldDelegate) => !identical(wave, oldDelegate.wave);
}
