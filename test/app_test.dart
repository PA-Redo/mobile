import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pa_mobile/app.dart';
import 'package:pa_mobile/flows/home/ui/home_screen.dart';

void main() {
  final navigatorKey = GlobalKey<NavigatorState>();
  group('App', () {
    testWidgets('renders', (tester) async {
      //create key
      await tester.pumpWidget(
        MyApp(
          isLogged: false,
          isVolunteer: false,
          navigatorKey: navigatorKey,
        ),
      );
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
