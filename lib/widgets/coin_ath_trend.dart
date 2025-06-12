// lib/widgets/coin_ath_trend.dart
import 'package:flutter/material.dart';
import '../model/coin.dart';

class CoinAthTrend extends StatelessWidget {
  final Coin coin;

  const CoinAthTrend({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final bool isPriceUp = coin.priceChangePercentage24h >= 0;
    final double athDifferencePercent =
        ((coin.ath - coin.currentPrice).abs() / coin.ath) * 100;
    final bool isNearAth = athDifferencePercent <= 5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isNearAth
            ? const Row(
                children: [
                  Icon(Icons.whatshot, color: Colors.orange, size: 18),
                  SizedBox(width: 4),
                  Text(
                    'Near ATH!',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
        Row(
          children: [
            Icon(
              isPriceUp ? Icons.arrow_upward : Icons.arrow_downward,
              color: isPriceUp ? Colors.green : Colors.red,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              //'${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
              '${coin.priceChangePercentage24h >= 0 ? '+' : ''}${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
  
              style: TextStyle(
                color: isPriceUp ? Colors.green : Colors.red,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
      ],
    );
  }
}