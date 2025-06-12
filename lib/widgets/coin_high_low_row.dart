// lib/widgets/coin_high_low_row.dart
import 'package:flutter/material.dart';
import '../model/coin.dart';

class CoinHighLowRow extends StatelessWidget {
  final Coin coin;

  const CoinHighLowRow({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '24h High: \$${coin.high24h.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.green.shade700),
        ),
        Text(
          '24h Low: \$${coin.low24h.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.red.shade700),
        ),
      ],
    );
  }
}