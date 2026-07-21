import 'package:flutter_test/flutter_test.dart';
import 'package:practice_ai_front_demo/presentation/pages/home/main_shell.dart';

void main() {
  test('maps main navigation paths to their button positions', () {
    expect(mainNavIndexForLocation('/home'), 0);
    expect(mainNavIndexForLocation('/schedule'), 1);
    expect(mainNavIndexForLocation('/bookkeeping'), 2);
    expect(mainNavIndexForLocation('/profile'), 3);
  });
}
