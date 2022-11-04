import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../common/util/screen_util.dart';
import 'gradient_icon.dart';
import 'heartbeat_icon.dart';
import 'radial_progress_indicator.dart';

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
