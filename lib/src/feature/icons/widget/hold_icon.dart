import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// {@template hold_icon}
/// HoldIcon widget
/// {@endtemplate}
class HoldIcon extends StatefulWidget {
  /// {@macro hold_icon}
  const HoldIcon({
    this.size = 64,
    super.key,
  });

  /// The size of the progress indicator
  final double size;

  @override
  State<HoldIcon> createState() => _HoldIconState();
}

class _HoldIconState extends State<HoldIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      value: 0,
    );
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
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned.fill(
                  child: GestureDetector(
                    onTapDown: (_) => _controller.forward(),
                    onTapUp: (_) => _controller.reverse(),
                    onTapCancel: () => _controller.reverse(),
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 1, end: 1.5).animate(_controller),
                      child: RotationTransition(
                        turns: _controller,
                        child: const CustomPaint(
                          painter: _CircularSawPainter(),
                        ),
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  ignoring: true,
                  child: Center(
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 1, end: 1.5).animate(_controller),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.rectangle,
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                'HOLD',
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
                                style: GoogleFonts.coiny(
                                  fontSize: widget.size / 4,
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
              ],
            ),
          ),
        ),
      );
}

class _CircularSawPainter extends CustomPainter {
  const _CircularSawPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // --- RRect --- //

    final rrectPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    const offset = 3.0;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.width / 2.5),
    );
    final rrectPath = Path()..addRRect(rrect);
    final rrectOffset = rrect.deflate(offset);

    canvas
      ..drawShadow(rrectPath, Colors.black, 2, true)
      ..drawShadow(rrectPath, Colors.black, 4, true)
      ..drawShadow(rrectPath, Colors.black, 8, true)
      ..drawRRect(rrect, rrectPaint)
      ..save()
      ..clipRRect(rrectOffset);

    // --- Stripes --- //

    final stripesPath = Path()..fillType = PathFillType.evenOdd;
    const stripesCount = 6;
    final stripeHeight = size.height / stripesCount / 2;

    final stripesPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = stripeHeight / 1.8
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < stripesCount * 1.8; i++) {
      final d = stripeHeight * i * 2;
      stripesPath
        ..moveTo(0, d)
        ..lineTo(d, 0);
    }
    canvas
      ..drawPath(stripesPath, stripesPaint)
      ..restore();
  }

  Path circlePath({required Offset position, required Size size}) {
    final widthf = size.width / 2.0;
    final heightf = size.height / 2.0;
    final start = position - Offset(widthf, heightf);
    var end = position + Offset(widthf, heightf);
    final path = Path();
    final radius = math.min(widthf, heightf) * 2;
    end = start + Offset(radius, radius);
    final rect = Rect.fromPoints(start, end);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    path.addRRect(rrect);
    return path;
  }

  @override
  bool shouldRepaint(covariant _CircularSawPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(covariant _CircularSawPainter oldDelegate) => false;
}
