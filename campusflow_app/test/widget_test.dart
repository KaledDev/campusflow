import 'package:campusflow_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CampusFlow title screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusFlowApp());

    expect(find.text('CampusFlow'), findsOneWidget);
  });
}
