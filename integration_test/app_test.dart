import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:playground/src/common/initialization/initialization.dart';
import 'package:playground/src/common/widget/app.dart';

void main() => Future<void>(() async {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

      setUpAll(() async {
        await $initializeApp();
      });

      tearDownAll(() async {
        await $disposeApp();
      });

      group('end-to-end test', () {
        testWidgets('app', (tester) async {
          await tester.pumpWidget(const App());
          await tester.pumpAndSettle(const Duration(seconds: 5));
          expect(find.byType(App), findsOneWidget);
          expect(find.byType(MaterialApp), findsOneWidget);
          expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        });
      });
    });
