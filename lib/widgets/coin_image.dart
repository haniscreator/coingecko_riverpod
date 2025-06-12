// lib/widgets/coin_image.dart
import 'package:flutter/material.dart';

class CoinImage extends StatelessWidget {
  final String imageUrl;

  const CoinImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.white,
      backgroundImage: NetworkImage(imageUrl),
    );
  }
}