import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:floatwise/app/app.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('FloatWise smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: FloatWiseApp()));

    await tester.pumpAndSettle();

    expect(find.text('FloatWise'), findsOneWidget);
  });
}
