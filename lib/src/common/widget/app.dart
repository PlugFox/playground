import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../constant/environment.dart';
import '../localization/localization.dart';
import '../router/router.dart';
import 'error_screen.dart';

/// {@template app}
/// App widget
/// {@endtemplate}
class App extends StatefulWidget {
  /// {@macro app}
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppRouter _router = AppRouter();

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: kTitle,
        restorationScopeId: 'app',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ui.window.platformBrightness == ui.Brightness.light ? ThemeData.light() : ThemeData.dark(),
        localizationsDelegates: const <LocalizationsDelegate<Object?>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          Localization.delegate,
        ],
        supportedLocales: Localization.supportedLocales,
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
        routeInformationProvider: _router.routeInformationProvider,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: Banner(
            message: 'PREVIEW',
            location: BannerLocation.topEnd,
            child: child ?? ErrorScreen(exception: Exception('No child')),
          ),
        ),
      );
}
