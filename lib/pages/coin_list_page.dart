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
                                'CryptoX',
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
                            'Crypto In Minutes',
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

                      // 🔹 Add this logic here
                      final bool isPriceUp = coin.priceChangePercentage24h >= 0;
                      final double athDifferencePercent =
                          ((coin.ath - coin.currentPrice).abs() / coin.ath) * 100;
                      final bool isNearAth = athDifferencePercent <= 5;
                      
                        
                      return TweenAnimationBuilder<Offset>(
                        duration: Duration(milliseconds: 500 + index * 100),
                        tween: Tween(begin: const Offset(0, 0.2), end: Offset.zero),
                        curve: Curves.easeOut,
                        builder: (context, offset, child) {
                          return Transform.translate(
                            offset: Offset(0, offset.dy * 50),
                            child: child,
                          );
                        },
                        child: Stack(
  alignment: Alignment.topCenter,
  children: [
    // Card
    Container(
      margin: const EdgeInsets.only(top: 24), // Space for the image
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 16), // Top padding for spacing below image
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
  // 🔷 Name and Price
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        coin.name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        '\$${coin.currentPrice.toStringAsFixed(2)}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ],
  ),
  const SizedBox(height: 8),

  // 🔸 24h High / Low
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        '24h High: \$${coin.high24h.toStringAsFixed(2)}',
        style: TextStyle(color: Colors.green.shade700),
      ),
      Text(
        '24h Low: \$${coin.low24h.toStringAsFixed(2)}',
        style: TextStyle(color: Colors.red.shade700),
      ),
    ],
  ),
  const SizedBox(height: 4),

  // 🔻 ATH
  Align(
    alignment: Alignment.centerLeft,
    child: Text(
      'ATH: \$${coin.ath.toStringAsFixed(2)}',
      style: const TextStyle(color: Colors.blueGrey),
    ),
  ),

  const SizedBox(height: 6),

  // 🔼 Trend + 🔥 ATH Status
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      

      // 🔥 ATH indicator
      if (isNearAth)
        const Row(
          children: [
            Icon(Icons.whatshot, color: Colors.orange, size: 18),
            SizedBox(width: 4),
            Text(
              'Near ATH!',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),

      // Price trend arrow
      Row(
        children: [
          Icon(
            isPriceUp ? Icons.arrow_upward : Icons.arrow_downward,
            color: isPriceUp ? Colors.green : Colors.red,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            '${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
            style: TextStyle(
              color: isPriceUp ? Colors.green : Colors.red,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),

    ],
  ),
],

          ),
        ),
      ),
    ),

    // Coin Logo (positioned overlapping card)
    Positioned(
      top: 0,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Image.network(
          coin.image,
          width: 48,
          height: 48,
        ),
      ),
    ),
  ],
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
