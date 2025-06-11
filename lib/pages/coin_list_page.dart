import 'package:crypto_riverpod/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/coin_provider.dart';
import '../model/coin.dart';

class CoinListPage extends ConsumerStatefulWidget {
  const CoinListPage({super.key});

  @override
  ConsumerState<CoinListPage> createState() => _CoinListPageState();
}

class _CoinListPageState extends ConsumerState<CoinListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Near bottom, trigger fetch
      ref.read(coinListProvider.notifier).fetchCoins();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coinListAsync = ref.watch(coinListProvider);

    return Scaffold(
      appBar: AppBar(
      title: const Text("Crypto Coins"),
      actions: [
        Consumer(
          builder: (context, ref, _) {
            final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;
            return Switch(
              value: isDarkMode,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).state =
                    value ? ThemeMode.dark : ThemeMode.light;
              },
            );
          },
        ),
      ],
    ),

      body: coinListAsync.when(
        data: (coins) => ListView.builder(
          controller: _scrollController,
          itemCount: coins.length,
          itemBuilder: (context, index) {
            final Coin coin = coins[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: Theme.of(context).cardColor,
              child: ListTile(
                leading: Image.network(coin.image, width: 32),
                title: Text(
                  coin.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current: \$${coin.currentPrice.toStringAsFixed(2)}'),
                    Text('24h High: \$${coin.high24h.toStringAsFixed(2)}'),
                    Text('24h Low: \$${coin.low24h.toStringAsFixed(2)}'),
                    Text('ATH: \$${coin.ath.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
