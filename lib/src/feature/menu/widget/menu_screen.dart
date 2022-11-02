import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/router/routes.dart';

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
              floating: true,
              snap: true,
            ),
            /* SliverFixedExtentList(
              itemExtent: 50,
              delegate: SliverChildListDelegate.fixed(
                <Widget>[
                  ListTile(
                    dense: true,
                    title: const Text('Highlight Icons'),
                    onTap: () => context.goHighlightIcons(),
                  ),
                ],
              ),
            ), */
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                      title: 'Highlight Icons',
                      onTap: () => context.goHighlightIcons(),
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
    void Function()? onTap,
    super.key,
  }) : super(
          child: Card(
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
                    style: _style,
                  ),
                ),
              ),
            ),
          ),
        );

  static final TextStyle _style = GoogleFonts.robotoMono(
    height: 1,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    shadows: <Shadow>[
      const Shadow(
        color: Colors.black26,
        offset: Offset(6, 4),
        blurRadius: 4,
      ),
    ],
  );
}
