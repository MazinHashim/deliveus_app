import 'package:deleveus_app/app/app.dart';
import 'package:deleveus_app/app/view/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      // await tester.pumpWidget(const App());
      expect(find.byType(App), findsOneWidget);
    });
  });
}
