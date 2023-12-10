import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:life_log_2/utils/log_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // NEW
  MyLogger.testColors();
  testWidgets('first integration test', (tester) async {
    expect(1, 1);
  });
}
