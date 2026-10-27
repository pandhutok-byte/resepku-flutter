import 'package:flutter_test/flutter_test.dart';
import 'package:uts/main.dart';

void main() {
  testWidgets('ResepKu tampil dengan benar', (WidgetTester tester) async {
    await tester.pumpWidget(const ResepKuApp());

    expect(find.text('ResepKu'), findsOneWidget);
  });
}
