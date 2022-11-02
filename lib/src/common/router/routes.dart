import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature/highlight_icons/widget/highlight_icons_screen.dart';
import '../../feature/menu/widget/menu_screen.dart';

final List<GoRoute> $routes = <GoRoute>[
  GoRoute(
    name: 'Home',
    path: '/',
    redirect: (context, state) => state.namedLocation(
      'Menu',
      params: state.params,
      queryParams: state.queryParams,
    ),
  ),
  GoRoute(
    name: 'Menu',
    path: '/menu',
    builder: (context, state) => const MenuScreen(),
    routes: <RouteBase>[
      GoRoute(
        name: 'HighlightIcons',
        path: 'hl-icons',
        builder: (context, state) => const HighlightIconsScreen(),
      ),
    ],
  ),
];

extension GoRoutesExtension on BuildContext {
  GoRouter get _router => GoRouter.of(this);

  void pop() => _router.pop();

  /// Navigate to the Home route.
  void goHome() => _router.goNamed('Home');

  /// Navigate to the HighlightIcons route.
  void goHighlightIcons() => _router.goNamed('HighlightIcons');
}
