class Coin {
  final String id;
  final String name;
  final String image;
  final double currentPrice;
  final double high24h;
  final double low24h;
  final double ath;

  Coin({
    required this.id,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.high24h,
    required this.low24h,
    required this.ath,
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
    );
  }
}
