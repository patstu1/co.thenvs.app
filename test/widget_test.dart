import 'package:flutter_test/flutter_test.dart';
import 'package:nvs_app/src/app.dart';

void main() {
  testWidgets('App should start without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NVSApp());

    // Verify that the app loads
    expect(find.text('NVS'), findsWidgets);
  });
}