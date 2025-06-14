import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/coin_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/coin_card.dart';

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
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
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
                            'Trade in Minutes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: coinListAsync.when(
                  data: (coins) => ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: coins.length,
                    itemBuilder: (context, index) {
                      final coin = coins[index];
                      return CoinCard(
                        coin: coin,
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

class AngledRightNotchCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.8);
    final controlPoint = Offset(size.width * 0.9, size.height * 0.6);
    final endPoint = Offset(0, size.height);
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
