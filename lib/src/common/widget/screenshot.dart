@experimental

import 'dart:typed_data' as td;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:l/l.dart';
import 'package:meta/meta.dart';

import '../util/downloader.dart';

/// {@template screenshot_scope}
/// ScreenshotScope widget
/// {@endtemplate}
class ScreenshotScope extends StatelessWidget {
  /// {@macro screenshot_scope}
  const ScreenshotScope({
    required this.child,
    this.controller,
    super.key,
  });

  static Widget png({required Widget child, double pixelRatio = 6}) => _ScreenshotTile.static(child, pixelRatio);
  static Widget gif({required Duration duration, required Widget child, double pixelRatio = 6}) =>
      _ScreenshotTile.animated(child, pixelRatio, duration);

  final ScreenshotController? controller;

  /// The widget below this widget in the tree.
  final Widget child;

  static Future<List<int>> takeScreenshot(
    BuildContext context, {
    double pixelRatio = 1.0,
  }) async {
    final boundary = _getBoundary(context);
    final image = await _getImage(boundary, pixelRatio);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes is! td.ByteData) throw UnsupportedError('Error converting image to bytes');
    return bytes.buffer.asUint8List();
  }

  static Future<List<int>> takeAnimation(
    BuildContext context, {
    Duration duration = const Duration(milliseconds: 1000),
    double pixelRatio = 1.0,
  }) async {
    const fps = 15;
    final boundary = _getBoundary(context);
    Stream<ui.Image> generateImages() async* {
      final stopwatch = Stopwatch()..start();
      try {
        final fpms = fps / 1000, framesToRender = duration.inMilliseconds * fpms;
        for (var i = 0; i < framesToRender; i++) {
          stopwatch.reset();
          final image = await _getImage(boundary, pixelRatio);
          yield image;
          final nextFrame = stopwatch.elapsedMilliseconds - fpms;
          if (nextFrame.isNegative) continue;
          await Future<void>.delayed(Duration(milliseconds: nextFrame.truncate()));
        }
      } on Object {
        rethrow;
      } finally {
        stopwatch.stop();
      }
    }

    final images = await generateImages().toList();
    final data = await Stream<ui.Image>.fromIterable(images).asyncMap<List<int>>((image) async {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      await Future<void>.delayed(Duration.zero);
      return bytes?.buffer.asUint8List() ?? (throw UnsupportedError('Error converting image to bytes'));
    }).toList();

    return compute<List<List<int>>, List<int>>(
      (data) async {
        final animation = img.Animation()
          ..backgroundColor = Colors.transparent.value
          //..width = images.map<int>((e) => e.width).reduce(math.max)
          //..height = images.map<int>((e) => e.height).reduce(math.max)
          ..loopCount = 0;
        for (final bytes in data) {
          //return img.Image.fromBytes(image.width, image.height, bytes.buffer.asUint8List());
          final png = (img.decodePng(bytes) ?? (throw UnsupportedError('Error decoding image')))..duration = 1000 ~/ 15;
          //..duration = duration.inMilliseconds ~/ data.length;
          animation.addFrame(png);
        }
        return img.encodeGifAnimation(animation, samplingFactor: 20) ??
            (throw UnsupportedError('Error encoding image'));
      },
      data,
    );
  }

  static RenderRepaintBoundary _getBoundary(BuildContext context) {
    RenderRepaintBoundary? boundary;
    context.visitAncestorElements((element) {
      if (element.widget is ScreenshotScope) return false;
      final renderObject = element.renderObject;
      if (renderObject is RenderRepaintBoundary) boundary = renderObject;
      return true;
    });
    return boundary ?? (throw UnsupportedError('No ScreenshotScope found'));
  }

  static Future<ui.Image> _getImage(RenderRepaintBoundary boundary, double pixelRatio) =>
      boundary.toImage(pixelRatio: pixelRatio).then<ui.Image>((image) => image.clone());

  @override
  Widget build(BuildContext context) => RepaintBoundary(
        child: _ScreenshotControlled(
          controller: controller,
          child: child,
        ),
      );
}

class ScreenshotController {
  _ScreenshotControlledElement? _context;

  Future<List<int>> takeScreenshot({
    double pixelRatio = 1.0,
  }) {
    final context = _context;
    if (context == null) throw UnsupportedError('No ScreenshotScope found');
    return ScreenshotScope.takeScreenshot(context, pixelRatio: pixelRatio);
  }

  Future<List<int>> takeAnimation({
    Duration duration = const Duration(milliseconds: 1000),
    double pixelRatio = 1.0,
  }) {
    final context = _context;
    if (context == null) throw UnsupportedError('No ScreenshotScope found');
    return ScreenshotScope.takeAnimation(context, pixelRatio: pixelRatio, duration: duration);
  }

  void dispose() => _context = null;
}

class _ScreenshotControlled extends ProxyWidget {
  const _ScreenshotControlled({required super.child, required this.controller});

  final ScreenshotController? controller;

  @override
  Element createElement() => _ScreenshotControlledElement(this);
}

class _ScreenshotControlledElement extends ComponentElement {
  _ScreenshotControlledElement(_ScreenshotControlled super.widget);

  @override
  Widget build() => (widget as _ScreenshotControlled).child;

  @override
  void mount(Element? parent, Object? newSlot) {
    (widget as _ScreenshotControlled).controller?._context = this;
    super.mount(parent, newSlot);
  }

  @override
  void update(covariant _ScreenshotControlled newWidget) {
    final controller = (widget as _ScreenshotControlled).controller;
    if (controller != null && controller._context == this) controller._context = null;
    newWidget.controller?._context = this;
    super.update(newWidget);
  }

  @override
  void unmount() {
    final controller = (widget as _ScreenshotControlled).controller;
    if (controller != null && controller._context == this) controller._context = null;
    super.unmount();
  }
}

class _ScreenshotTile extends StatefulWidget {
  const _ScreenshotTile.static(this.child, this.pixelRatio)
      : _duration = null,
        _animated = false;
  const _ScreenshotTile.animated(this.child, this.pixelRatio, Duration duration)
      : _duration = duration,
        _animated = true;

  final Widget child;
  final double pixelRatio;
  final bool _animated;
  final Duration? _duration;

  @override
  State<_ScreenshotTile> createState() => _ScreenshotTileState();
}

class _ScreenshotTileState extends State<_ScreenshotTile> {
  final controller = ScreenshotController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _saveBytes() async {
    final animated = widget._animated;
    final bytes = await (animated
        ? controller.takeAnimation(duration: widget._duration!, pixelRatio: 5)
        : controller.takeScreenshot(pixelRatio: 5));
    await Downloader.downloadBytes(bytes, animated ? 'animation.gif' : 'screenshot.png');
    l.i('Saved ${animated ? 'animation' : 'screenshot'}');
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: Image.memory(Uint8List.fromList(bytes)),
      ),
    ).ignore();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Positioned.fill(
            child: ScreenshotScope(
              controller: controller,
              child: widget.child,
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            width: 24,
            height: 24,
            child: IconButton(
              alignment: Alignment.center,
              constraints: const BoxConstraints(maxHeight: 24, maxWidth: 24),
              padding: EdgeInsets.zero,
              splashRadius: 24,
              icon: const Icon(Icons.download),
              onPressed: _saveBytes,
            ),
          ),
        ],
      );
}
