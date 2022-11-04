import 'package:flutter/material.dart';
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
class _PresentIconState extends State<PresentIcon> with SingleTickerProviderStateMixin {
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
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0, .5, curve: Curves.easeInOut)));
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
    try {
      _controller.reset();
    } on TickerCanceled {
      // the animation is no longer running
    } finally {
      _controller
        ..reset()
        ..repeat();
    }
  }

  @override
  Widget build(BuildContext context) => Center(
        child: RepaintBoundary(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Center(
                  child: RotationTransition(
                    turns: _turns,
                    child: IconButton(
                      onPressed: () {},
                      iconSize: widget.size,
                      color: Colors.pink,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.expand(width: widget.size, height: widget.size),
                      splashRadius: widget.size * .75,
                      icon: const Icon(
                        FontAwesomeIcons.gift,
                        shadows: [
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
