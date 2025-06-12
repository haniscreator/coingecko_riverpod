class Coin {
  final String id;
  final String name;
  final String image;
  final double currentPrice;
  final double high24h;
  final double low24h;
  final double ath;
  final double priceChangePercentage24h;
  final double athChangePercentage;
  

  Coin({
    required this.id,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.high24h,
    required this.low24h,
    required this.ath,
    required this.priceChangePercentage24h,
    required this.athChangePercentage,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      currentPrice: (json['current_price'] as num).toDouble(),
      high24h: (json['high_24h'] as num).toDouble(),
      low24h: (json['low_24h'] as num).toDouble(),
      ath: (json['ath'] as num).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] as num).toDouble(),
      athChangePercentage: (json['ath_change_percentage'] as num).toDouble(),
    );
  }
}
