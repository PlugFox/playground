import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    routes: const <RouteBase>[],
  ),
];

extension GoRoutesExtension on BuildContext {
  GoRouter get _router => GoRouter.of(this);

  void pop() => _router.pop();

  /// Navigate to the Home route.
  void goHome() => _router.goNamed('Home');
}
