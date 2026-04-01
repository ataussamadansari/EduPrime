import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_routes.dart';
import '../../core/widgets/app_button.dart';

class _OnboardingPage {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  static const List<_OnboardingPage> _pages = [
    _OnboardingPage(
      title: 'Learn from the Best',
      subtitle:
          'Access 500+ courses taught by industry experts. Study at your own pace, anytime, anywhere.',
      icon: Icons.menu_book_rounded,
      gradient: [Color(0xFF6C63FF), Color(0xFF9D97FF)],
    ),
    _OnboardingPage(
      title: 'Track Your Progress',
      subtitle:
          'Monitor attendance, assignments, and exam results in one place. Stay on top of your learning journey.',
      icon: Icons.insights_rounded,
      gradient: [Color(0xFFFF6584), Color(0xFFFFB347)],
    ),
    _OnboardingPage(
      title: 'Earn Certificates',
      subtitle:
          'Complete courses and earn industry-recognized certificates. Boost your career with verified credentials.',
      icon: Icons.workspace_premium_rounded,
      gradient: [Color(0xFF43E97B), Color(0xFF38F9D7)],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: AppConstants.animNormal,
        curve: Curves.easeInOut,
      );
    } else {
      Get.offNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final page = _pages[index];
              return _OnboardingPageWidget(page: page, index: index);
            },
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.spaceLG,
                AppConstants.spaceLG,
                AppConstants.spaceLG,
                AppConstants.spaceXL,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.bgDark : AppColors.bgLight,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppConstants.radiusXXL),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicator
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.primary.withValues(alpha: 0.25),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceLG),

                  // Next / Get Started button
                  AppButton(
                    label: _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onTap: _next,
                    icon: _currentPage == _pages.length - 1
                        ? Icons.rocket_launch_rounded
                        : null,
                  ),

                  const SizedBox(height: AppConstants.spaceMD),

                  // Skip
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: () => Get.offNamed(AppRoutes.login),
                      child: Text(
                        'Skip',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageWidget extends StatelessWidget {
  final _OnboardingPage page;
  final int index;

  const _OnboardingPageWidget({required this.page, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Illustration area
        Expanded(
          flex: 6,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: page.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(page.icon, size: 72, color: Colors.white),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.6, 0.6),
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 400.ms),
                ],
              ),
            ),
          ),
        ),

        // Text area
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spaceLG,
              AppConstants.spaceLG,
              AppConstants.spaceLG,
              AppConstants.spaceXXL + 80,
            ),
            child: Column(
              children: [
                Text(
                  page.title,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate(delay: 100.ms)
                    .slideY(begin: 0.3, end: 0, duration: 400.ms)
                    .fadeIn(duration: 400.ms),
                const SizedBox(height: AppConstants.spaceMD),
                Text(
                  page.subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate(delay: 200.ms)
                    .slideY(begin: 0.3, end: 0, duration: 400.ms)
                    .fadeIn(duration: 400.ms),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
