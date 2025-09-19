import 'package:flutter_test/flutter_test.dart';
import 'package:nvs_app/main.dart';

void main() {
  testWidgets('NVS App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NVSApp());

    // Verify that the app starts with the auth screen
    expect(find.text('NVS'), findsOneWidget);
    expect(find.text('Meet. Connect. Explore.'), findsOneWidget);
    
    // Verify auth form elements are present
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('Auth screen toggle functionality', (WidgetTester tester) async {
    await tester.pumpWidget(const NVSApp());

    // Initially should show "Sign In"
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Don\'t have an account? Sign up'), findsOneWidget);

    // Tap the toggle button
    await tester.tap(find.text('Don\'t have an account? Sign up'));
    await tester.pump();

    // Should now show "Sign Up"
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Already have an account? Sign in'), findsOneWidget);
  });
}