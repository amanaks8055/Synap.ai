import 'package:flutter/material.dart';
import '../../screens/home_screen.dart';
import '../../screens/explore_screen.dart';
import '../../screens/startup/startup_kit_screen.dart';
import '../../screens/favorites_screen.dart';
import '../../screens/menu_screen.dart';
import '../../theme/app_theme.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    ExploreScreen(),
    StartupKitScreen(),
    FavoritesScreen(),
    MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: SynapStyles.bgPrimary(context),
          border: Border(top: BorderSide(color: SynapStyles.border(context), width: 0.5)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
                _navItem(1, Icons.explore_rounded, Icons.explore_outlined, 'Explore'),
                _navItem(2, Icons.rocket_launch_rounded, Icons.rocket_launch_outlined, 'Startup'),
                _navItem(3, Icons.favorite_rounded, Icons.favorite_border_rounded, 'Favorites'),
                _navItem(4, Icons.menu_rounded, Icons.menu_outlined, 'Menu'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int i, IconData active, IconData inactive, String label) {
    final sel = _index == i;
    return GestureDetector(
      onTap: () => setState(() => _index = i),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(sel ? active : inactive, color: sel ? SynapColors.accent : SynapStyles.textMuted(context), size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: sel ? SynapColors.accent : SynapStyles.textMuted(context),
                fontSize: 11,
                fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
