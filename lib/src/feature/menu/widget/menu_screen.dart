import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/router/routes.dart';
import '../../../common/util/screen_util.dart';

/// {@template menu_screen}
/// MenuScreen widget
/// {@endtemplate}
class MenuScreen extends StatelessWidget {
  /// {@macro menu_screen}
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              title: Text('Menu'),
              centerTitle: true,
              floating: true,
              snap: true,
              pinned: true,
            ),
            SliverPadding(
              padding: ScreenUtil.centerPadding(context),
              sliver: DefaultTextStyle(
                style: GoogleFonts.robotoMono(
                  fontSize: 24,
                ),
                child: SliverGrid.extent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: <Widget>[
                    MenuCard(
                      title: 'Icons',
                      onTap: () => context.goIcons(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

/// {@template menu_card}
/// MenuCard widget
/// {@endtemplate}
class MenuCard extends GridTile {
  /// {@macro menu_card}
  MenuCard({
    required String title,
    /* String? description, */
    VoidCallback? onTap,
    super.key,
  }) : super(
          child: Builder(
            builder: (context) => Card(
              color: Theme.of(context).primaryColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: EdgeInsets.zero,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoMono(
                        height: 1,
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          const Shadow(
                            offset: Offset(4, 2),
                            color: Colors.black26,
                            blurRadius: 8,
                          ),
                          const Shadow(
                            offset: Offset(4, 2),
                            color: Colors.black26,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
}
