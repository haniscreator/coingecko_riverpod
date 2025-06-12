// lib/widgets/coin_ath_row.dart
import 'package:flutter/material.dart';
import '../model/coin.dart';

class CoinAthRow extends StatelessWidget {
  final Coin coin;

  const CoinAthRow({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'ATH: \$${coin.ath.toStringAsFixed(2)}',
        style: const TextStyle(color: Colors.blueGrey),
      ),
    );
  }
}