import 'package:flutter_test/flutter_test.dart';
import 'package:practice_ai_front_demo/data/models/bookkeeping/record.dart';

void main() {
  test('formats expense display from type with positive amount', () {
    const record = Record(
      id: 1,
      type: 1,
      typeName: '支出',
      amount: -12.5,
      amountDisplay: '-¥12.50',
      recordDate: '2026-07-21',
    );

    expect(record.absoluteAmountDisplay, '¥12.50');
    expect(record.signedAmountDisplay, '-¥12.50');
  });

  test('formats income display from type with positive amount', () {
    const record = Record(
      id: 2,
      type: 2,
      typeName: '收入',
      amount: 12.5,
      amountDisplay: '+¥12.50',
      recordDate: '2026-07-21',
    );

    expect(record.absoluteAmountDisplay, '¥12.50');
    expect(record.signedAmountDisplay, '+¥12.50');
  });
}
