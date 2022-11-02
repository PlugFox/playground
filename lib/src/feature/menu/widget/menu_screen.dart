import 'package:flutter/material.dart';

/// {@template menu_screen}
/// MenuScreen widget
/// {@endtemplate}
class MenuScreen extends StatelessWidget {
  /// {@macro menu_screen}
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
        ),
        body: const SafeArea(child: Placeholder()),
      );
}
