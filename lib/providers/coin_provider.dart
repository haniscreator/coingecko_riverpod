import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/coin.dart';
import '../repository/coin_repository.dart';

final coinRepositoryProvider = Provider((ref) => CoinRepository());

final coinListProvider =
    StateNotifierProvider<CoinListNotifier, AsyncValue<List<Coin>>>(
  (ref) => CoinListNotifier(ref.watch(coinRepositoryProvider)),
);

class CoinListNotifier extends StateNotifier<AsyncValue<List<Coin>>> {
  CoinListNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchCoins();
  }

  final CoinRepository _repository;
  int _currentPage = 1;
  final int _limit = 6;
  bool _isFetching = false;

  List<Coin> _coins = [];

  Future<void> fetchCoins() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      final newCoins =
          await _repository.fetchCoins(page: _currentPage, limit: _limit);
      _coins.addAll(newCoins);
      state = AsyncValue.data(List.from(_coins));
      _currentPage++;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isFetching = false;
    }
  }
}
