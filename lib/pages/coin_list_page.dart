import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/coin.dart';
import '../providers/coin_provider.dart';
import '../providers/theme_provider.dart';

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
      ref.read(coinListProvider.notifier).fetchCoins();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coinListAsync = ref.watch(coinListProvider);
    final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Transparent status bar
          statusBarIconBrightness: Brightness.light,
        ),
        child: SafeArea(
          top: false, // Allow drawing behind status bar
          child: Column(
            children: [
              // 🔶 Gradient AppBar with Custom Shape
              Stack(
                children: [
                  ClipPath(
                    clipper: AngledRightNotchCurveClipper(),
                    child: Container(
                      height: 210,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.deepOrange, Colors.orange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 48, 16, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // AppBar top row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Orypto',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isDarkMode
                                      ? Icons.dark_mode
                                      : Icons.light_mode,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  ref.read(themeModeProvider.notifier).state =
                                      isDarkMode
                                          ? ThemeMode.light
                                          : ThemeMode.dark;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Buy & Sell\nCrypto In Minutes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Coin List
              Expanded(
                child: coinListAsync.when(
                  data: (coins) => ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: coins.length,
                    itemBuilder: (context, index) {
                      final Coin coin = coins[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Coin image
                                Image.network(coin.image, width: 40, height: 40),
                                const SizedBox(width: 12),

                                // Coin details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Name and current price row
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            coin.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '\$${coin.currentPrice.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Icon(
                                                coin.priceChangePercentage24h >= 0
                                                    ? Icons.arrow_upward
                                                    : Icons.arrow_downward,
                                                size: 16,
                                                color: coin.priceChangePercentage24h >= 0
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      // 24h High and Low
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'High: \$${coin.high24h.toStringAsFixed(2)}',
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            'Low: \$${coin.low24h.toStringAsFixed(2)}',
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 6),

                                      // ATH with flame if close
                                      Row(
                                        children: [
                                          Text(
                                            'ATH: \$${coin.ath.toStringAsFixed(2)}',
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                          const SizedBox(width: 6),
                                          if (coin.athChangePercentage.abs() < 5)
                                            const Icon(
                                              Icons.local_fire_department,
                                              color: Colors.orange,
                                              size: 16,
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                      
                    },
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔶 Custom Clipper with Smooth Curve at "D"
class AngledRightNotchCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // A → B (top edge)
    path.moveTo(0, 0);
    path.lineTo(size.width, 0); // A → B

    // B → C (right vertical drop)
    path.lineTo(size.width, size.height * 0.8); // B → C

    // C → D → E (curve from C to E with D as control point)
    final controlPoint = Offset(size.width * 0.9, size.height * 0.6); // D
    final endPoint = Offset(0, size.height); // E

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    // E → A (bottom-left to top-left)
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
