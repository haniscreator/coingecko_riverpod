import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/coin.dart';

class CoinRepository {
  Future<List<Coin>> fetchCoins({required int page, int limit = 5}) async {
    final url = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$limit&page=$page');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Coin.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load coins');
    }
  }
}
