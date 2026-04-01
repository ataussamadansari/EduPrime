import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_routes.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/course_card.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models/course_model.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardController _controller;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(DashboardController());
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App bar ──────────────────────────────────────────────────────
          SliverAppBar(
            floating: true,
            backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning 👋',
                  style: AppTextStyles.caption.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                Text(
                  _controller.user['name'],
                  style: AppTextStyles.h2.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(right: AppConstants.spaceMD),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(_controller.user['avatar']),
                ),
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spaceMD),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Banner Carousel ──────────────────────────────────────
                _BannerCarousel(
                  controller: _controller,
                  pageController: _pageController,
                  isDark: isDark,
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppConstants.spaceLG),

                // ── Quick Stats ──────────────────────────────────────────
                const SectionHeader(title: 'Quick Stats')
                    .animate(delay: 100.ms)
                    .fadeIn(duration: 400.ms),
                const SizedBox(height: AppConstants.spaceMD),
                _QuickStats(controller: _controller, isDark: isDark)
                    .animate(delay: 150.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppConstants.spaceLG),

                // ── Continue Learning ────────────────────────────────────
                if (_controller.continueLearning.isNotEmpty) ...[
                  SectionHeader(
                    title: 'Continue Learning',
                    actionLabel: 'See All',
                    onAction: () {},
                  ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: AppConstants.spaceMD),
                  ..._controller.continueLearning.map(
                    (c) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppConstants.spaceMD),
                      child: _ContinueLearningCard(course: c, isDark: isDark),
                    ),
                  ),
                ],

                // ── Featured Courses ─────────────────────────────────────
                SectionHeader(
                  title: 'Featured Courses',
                  actionLabel: 'See All',
                  onAction: () {},
                ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
                const SizedBox(height: AppConstants.spaceMD),

                // Height calculated: 100 thumb + ~130 text content = 230
                SizedBox(
                  height: 260,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _controller.featuredCourses.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppConstants.spaceMD),
                    itemBuilder: (context, i) {
                      final course = _controller.featuredCourses[i];
                      return SizedBox(
                        width: 175,
                        child: CourseCard(
                          course: course,
                          onTap: () => Get.toNamed(
                            AppRoutes.courseDetail,
                            arguments: course,
                          ),
                        ),
                      )
                          .animate(delay: Duration(milliseconds: 350 + i * 80))
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: 0.2, end: 0);
                    },
                  ),
                ),

                const SizedBox(height: AppConstants.spaceXL),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Banner Carousel ──────────────────────────────────────────────────────────
class _BannerCarousel extends StatelessWidget {
  final DashboardController controller;
  final PageController pageController;
  final bool isDark;

  const _BannerCarousel({
    required this.controller,
    required this.pageController,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 155,
          child: PageView.builder(
            controller: pageController,
            itemCount: controller.banners.length,
            onPageChanged: (i) => controller.bannerIndex.value = i,
            itemBuilder: (context, i) {
              final banner = controller.banners[i];
              final color = Color(int.parse('FF${banner['color']}', radix: 16));
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.75)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                ),
                padding: const EdgeInsets.all(AppConstants.spaceMD),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            banner['title']!,
                            style:
                                AppTextStyles.h2.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            banner['subtitle']!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusFull),
                            ),
                            child: Text(
                              'Explore →',
                              style: AppTextStyles.labelMedium
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.local_offer_rounded,
                        color: Colors.white38, size: 56),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppConstants.spaceSM),
        Obx(() => AnimatedSmoothIndicator(
              activeIndex: controller.bannerIndex.value,
              count: controller.banners.length,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: AppColors.primary.withValues(alpha: 0.25),
                dotHeight: 6,
                dotWidth: 6,
                expansionFactor: 3,
              ),
            )),
      ],
    );
  }
}

// ── Quick Stats ──────────────────────────────────────────────────────────────
class _QuickStats extends StatelessWidget {
  final DashboardController controller;
  final bool isDark;

  const _QuickStats({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData(
        label: 'Enrolled',
        value: '${controller.user['enrolledCourses']}',
        icon: Icons.book_rounded,
        gradient: AppColors.primaryGradient,
      ),
      _StatData(
        label: 'Attendance',
        value: '${controller.user['attendancePercent']}%',
        icon: Icons.calendar_today_rounded,
        gradient: AppColors.greenGradient,
      ),
      _StatData(
        label: 'Pending',
        value: '${controller.user['pendingAssignments']}',
        icon: Icons.assignment_late_rounded,
        gradient: AppColors.orangeGradient,
      ),
    ];

    return Row(
      children: stats.asMap().entries.map((e) {
        final stat = e.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: e.key < stats.length - 1 ? AppConstants.spaceSM : 0,
            ),
            child: Container(
              padding: const EdgeInsets.all(AppConstants.spaceMD),
              decoration: BoxDecoration(
                gradient: stat.gradient,
                borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(stat.icon, color: Colors.white70, size: 20),
                  const SizedBox(height: 8),
                  Text(stat.value,
                      style: AppTextStyles.h1.copyWith(color: Colors.white)),
                  Text(
                    stat.label,
                    style:
                        AppTextStyles.caption.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _StatData {
  final String label;
  final String value;
  final IconData icon;
  final LinearGradient gradient;

  const _StatData({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
  });
}

// ── Continue Learning Card ────────────────────────────────────────────────────
class _ContinueLearningCard extends StatelessWidget {
  final CourseModel course;
  final bool isDark;

  const _ContinueLearningCard({required this.course, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Get.toNamed(AppRoutes.courseDetail, arguments: course),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            child: Image.network(
              course.thumbnail,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: AppColors.primary.withValues(alpha: 0.15),
                child: const Icon(Icons.play_circle_outline,
                    color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  course.title,
                  style: AppTextStyles.h3.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Last accessed: ${course.lastAccessed}',
                  style: AppTextStyles.caption.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: 6,
                  percent: course.progress,
                  backgroundColor:
                      isDark ? AppColors.borderDark : AppColors.borderLight,
                  progressColor: AppColors.primary,
                  barRadius: const Radius.circular(AppConstants.radiusFull),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(course.progress * 100).toInt()}% complete',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.spaceSM),
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow_rounded,
                color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
