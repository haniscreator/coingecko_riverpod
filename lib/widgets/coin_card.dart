// lib/widgets/coin_card.dart
import 'package:flutter/material.dart';
import '../model/coin.dart';
import 'coin_image.dart';
import 'coin_price_row.dart';
import 'coin_high_low_row.dart';
import 'coin_ath_row.dart';
import 'coin_ath_trend.dart';

class CoinCard extends StatelessWidget {
  final Coin coin;

  const CoinCard({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 24),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CoinPriceRow(coin: coin),
                  const SizedBox(height: 8),
                  CoinHighLowRow(coin: coin),
                  const SizedBox(height: 4),
                  CoinAthRow(coin: coin),
                  const SizedBox(height: 6),
                  CoinAthTrend(coin: coin),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child : TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(seconds: 5),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    // Subtle drop shadow
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),

                    // 🔥 Animated orange glow
                    BoxShadow(
                      color: Color(0x99FF9800),
                      blurRadius: 5 + (value * 5), // range: 20 → 30
                      spreadRadius: 1 + (value * 2), // range: 1 → 3
                    ),
                  ],
                ),
                child: child,
              );
            },
            child: CoinImage(imageUrl: coin.image),
          ),
        ),
      ],
    );
  }
}
