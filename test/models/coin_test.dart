import 'package:crypto_riverpod/model/coin.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('Coin model', () {
    test('isPriceUp returns true for positive change', () {
      final coin = Coin(
        id: 'bitcoin',
        name: 'Bitcoin',
        image: '',
        currentPrice: 30000.0,
        priceChangePercentage24h: 1.5,
        high24h: 31000.0,
        low24h: 29000.0,
        ath: 35000.0,
        athChangePercentage: 1.2,
      );

      expect(coin.isPriceUp, isTrue);
    });

    test('isPriceUp returns false for negative change', () {
      final coin = Coin(
        id: 'bitcoin',
        name: 'Bitcoin',
        image: '',
        currentPrice: 30000.0,
        priceChangePercentage24h: -2.1,
        high24h: 31000.0,
        low24h: 29000.0,
        ath: 35000.0,
        athChangePercentage: -1.5,
      );

      expect(coin.isPriceUp, isFalse);
    });
  });
}
