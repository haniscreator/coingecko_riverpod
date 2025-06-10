import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/coin_provider.dart';
import '../model/coin.dart';

class CoinListPage extends ConsumerWidget {
  const CoinListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinListAsync = ref.watch(coinListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Crypto Coins")),
      body: coinListAsync.when(
        data: (coins) => ListView.builder(
          itemCount: coins.length + 1, // +1 for loading button
          itemBuilder: (context, index) {
            if (index < coins.length) {
              final Coin coin = coins[index];
              return ListTile(
                leading: Image.network(coin.image, width: 32),
                title: Text(coin.name),
                subtitle: Text('\$${coin.currentPrice.toStringAsFixed(2)}'),
              );
            } else {
              // Load more button
              return Center(
                child: TextButton(
                  onPressed: () => ref.read(coinListProvider.notifier).fetchCoins(),
                  child: const Text('Load More'),
                ),
              );
            }
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
