// lib/widgets/coin_price_row.dart
import 'package:flutter/material.dart';
import '../model/coin.dart';

class CoinPriceRow extends StatelessWidget {
  final Coin coin;

  const CoinPriceRow({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          coin.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Text(
          '\$${coin.currentPrice.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}