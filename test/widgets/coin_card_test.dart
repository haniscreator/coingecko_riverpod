import 'package:crypto_riverpod/widgets/coin_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:crypto_riverpod/widgets/coin_card.dart';
import 'package:crypto_riverpod/model/coin.dart';

void main() {
  testWidgets('CoinCard renders correctly', (WidgetTester tester) async {
    final testCoin = Coin(
      id: 'bitcoin',
      name: 'Bitcoin',
      image: 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
      currentPrice: 30000.0,
      priceChangePercentage24h: 2.5,
      high24h: 31000.0,
      low24h: 29000.0,
      ath: 35000.0,
      athChangePercentage: 1.3
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoinCard(
              coin: testCoin,
              
            ),
          ),
        ),
      );

      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('\$30000.00'), findsOneWidget);
      expect(find.text('24h High: \$31000.00'), findsOneWidget);
      expect(find.text('24h Low: \$29000.00'), findsOneWidget);
      expect(find.text('ATH: \$35000.00'), findsOneWidget);
      expect(find.text('+2.50%'), findsOneWidget);
      expect(find.byType(CoinImage), findsOneWidget);
    });
  });
}
