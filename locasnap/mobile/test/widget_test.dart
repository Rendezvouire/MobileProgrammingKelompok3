import 'package:flutter_test/flutter_test.dart';
import 'package:locasnap/main.dart';

void main() {
  testWidgets('Home menampilkan nama aplikasi', (tester) async {
    await tester.pumpWidget(const LocaSnapApp());
    expect(find.text('LOCASNAP'), findsOneWidget);
  });
}