/// How to take a screenshot of widgets
import 'dart:typed_data' as td;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

  static Widget png(Widget child) => _ScreenshotTile.static(child);
  static Widget gif(Widget child) => _ScreenshotTile.animated(child);

  final ScreenshotController? controller;

  /// The widget below this widget in the tree.
  final Widget child;

  static Future<td.ByteData> takeScreenshot(
    BuildContext context, {
    double pixelRatio = 1.0,
  }) async {
    RenderRepaintBoundary? boundary;
    context.visitAncestorElements((element) {
      if (element.widget is ScreenshotScope) return false;
      final renderObject = element.renderObject;
      if (renderObject is RenderRepaintBoundary) boundary = renderObject;
      return true;
    });
    if (boundary == null) throw UnsupportedError('No ScreenshotScope found');
    final image = await boundary!.toImage(pixelRatio: pixelRatio);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes is! td.ByteData) throw UnsupportedError('Error converting image to bytes');
    return bytes;
  }

  static Future<td.ByteData> takeAnimation(BuildContext context) => takeScreenshot(context, pixelRatio: 5);

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

  Future<td.ByteData> takeScreenshot() {
    final context = _context;
    if (context == null) throw UnsupportedError('No ScreenshotScope found');
    return ScreenshotScope.takeScreenshot(context, pixelRatio: 5);
  }

  Future<td.ByteData> takeAnimation() {
    final context = _context;
    if (context == null) throw UnsupportedError('No ScreenshotScope found');
    return ScreenshotScope.takeAnimation(context);
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
  const _ScreenshotTile.static(this.child) : _animated = false;
  const _ScreenshotTile.animated(this.child) : _animated = true;

  final Widget child;
  final bool _animated;

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
    final bytes = await (animated ? controller.takeAnimation() : controller.takeScreenshot());
    await Downloader.downloadBytes(bytes.buffer.asInt8List(), animated ? 'animation.gif' : 'screenshot.png');
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
