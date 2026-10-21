import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ventus/app.dart';

void main() {
  testWidgets('VentusApp opens on the welcome screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: VentusApp()));
    await tester.pump();

    // The app boots in Azerbaijani (the default locale), so assert the AZ CTA.
    expect(find.text('Başlayaq'), findsOneWidget);
  });
}
