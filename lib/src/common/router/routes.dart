import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature/icons/widget/icons_screen.dart';
import '../../feature/menu/widget/menu_screen.dart';

final List<GoRoute> $routes = <GoRoute>[
  GoRoute(
    name: 'Home',
    path: '/',
    redirect: (context, state) => Uri(path: '/menu', queryParameters: state.queryParams).toString(),
  ),
  GoRoute(
    name: 'Menu',
    path: '/menu',
    builder: (context, state) => const MenuScreen(),
    routes: <RouteBase>[
      GoRoute(
        name: 'Icons',
        path: 'icons',
        builder: (context, state) => const IconsScreen(),
      ),
    ],
  ),
];

extension GoRoutesExtension on BuildContext {
  GoRouter get _router => GoRouter.of(this);

  void pop() => _router.pop();

  /// Navigate to the Home route.
  void goHome() => _router.goNamed('Home');

  /// Navigate to the Icons route.
  void goIcons() => _router.goNamed('Icons');
}
