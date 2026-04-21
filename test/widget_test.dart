import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:synap/app/app.dart';

void main() {
  testWidgets('App launches', (tester) async {
    await tester.pumpWidget(const SynapApp());
    expect(find.byType(SynapApp), findsOneWidget);

    // SplashScreen schedules delayed timers (400ms/1500ms/2000ms) and starts
    // periodic animation/timers. Pump past the delays, then unmount so dispose
    // cancels periodic work and the test ends cleanly.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
