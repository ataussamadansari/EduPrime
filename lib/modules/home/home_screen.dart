import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../dashboard/dashboard_screen.dart';
import '../courses/courses_screen.dart';
import '../my_learning/my_learning_screen.dart';
import '../profile/profile_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController get _ctrl => Get.find<HomeController>();

  final List<Widget> _pages = const [
    DashboardScreen(),
    CoursesScreen(),
    MyLearningScreen(),
    ProfileScreen(),
  ];

  DateTime? _lastBackPress;

  @override
  void initState() {
    super.initState();
    Get.put(HomeController());
  }

  Future<bool> _onWillPop() async {
    if (_ctrl.currentIndex.value != 0) {
      _ctrl.changePage(0);
      return false;
    }
    final now = DateTime.now();
    if (_lastBackPress == null ||
        now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
      _lastBackPress = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Press back again to exit'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          ),
          backgroundColor: AppColors.textPrimaryLight,
        ),
      );
      return false;
    }
    await SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) await _onWillPop();
      },
      child: Scaffold(
        // Scaffold handles bottom insets automatically
        body: GetBuilder<HomeController>(
          builder: (ctrl) => AnimatedSwitcher(
            duration: AppConstants.animNormal,
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: KeyedSubtree(
              key: ValueKey(ctrl.currentIndex.value),
              child: _pages[ctrl.currentIndex.value],
            ),
          ),
        ),
        bottomNavigationBar: GetBuilder<HomeController>(
          builder: (ctrl) => _BottomNav(
            currentIndex: ctrl.currentIndex.value,
            onTap: ctrl.changePage,
            isDark: isDark,
          ),
        ),
      ),
    );
  }
}

// ── Bottom Navigation Bar ────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isDark;

  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.isDark,
  });

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.explore_rounded, label: 'Courses'),
    _NavItem(icon: Icons.play_circle_rounded, label: 'My Learning'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top shadow line
          Container(
            height: 1,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            ),
          ),
          // Nav items — SafeArea handles system nav bar inset
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spaceSM,
                vertical: AppConstants.spaceSM,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_items.length, (i) {
                  final isActive = i == currentIndex;
                  return GestureDetector(
                    onTap: () => onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: AppConstants.animFast,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spaceMD,
                        vertical: AppConstants.spaceSM,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _items[i].icon,
                            color: isActive
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight),
                            size: 22,
                          ),
                          if (isActive) ...[
                            const SizedBox(width: 6),
                            Text(
                              _items[i].label,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                                .animate()
                                .slideX(begin: 0.3, end: 0, duration: 200.ms)
                                .fadeIn(duration: 200.ms),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
