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
import '../../core/widgets/network_image_widget.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/shimmer_widgets.dart';
import '../../data/models/dashboard_model.dart';
import '../../modules/notifications/notifications_screen.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardController _ctrl;
  late final PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(DashboardController());
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const DashboardShimmer();
        }
        if (_ctrl.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_ctrl.error.value,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.error),
                    textAlign: TextAlign.center),
                const SizedBox(height: AppConstants.spaceMD),
                TextButton(
                    onPressed: _ctrl.fetchDashboard,
                    child: const Text('Retry')),
              ],
            ),
          );
        }
        final data = _ctrl.dashboard.value;
        if (data == null) return const SizedBox.shrink();
        return _DashboardBody(
          ctrl: _ctrl,
          data: data,
          pageCtrl: _pageCtrl,
          isDark: isDark,
        );
      }),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final DashboardController ctrl;
  final DashboardModel data;
  final PageController pageCtrl;
  final bool isDark;

  const _DashboardBody({
    required this.ctrl,
    required this.data,
    required this.pageCtrl,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── AppBar ────────────────────────────────────────────────────────
        SliverAppBar(
          floating: true,
          backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.greeting,
                style: AppTextStyles.caption.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              Text(
                data.profile.name,
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
                  Icon(Icons.notifications_outlined,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight),
                  if (data.notificationUnreadCount > 0)
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
              onPressed: () => Get.to(() => const NotificationsScreen()),
            ),
            Padding(
              padding: const EdgeInsets.only(right: AppConstants.spaceMD),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: ClipOval(
                  child: NetworkImageWidget(
                    url: data.profile.avatarUrl,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    placeholder: Text(
                      data.profile.name.isNotEmpty
                          ? data.profile.name[0].toUpperCase()
                          : '?',
                      style: AppTextStyles.labelMedium
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SliverPadding(
          padding: const EdgeInsets.all(AppConstants.spaceMD),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ── Banners ────────────────────────────────────────────────
              _BannerCarousel(ctrl: ctrl, pageCtrl: pageCtrl, data: data)
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppConstants.spaceLG),

              // ── Quick Stats ────────────────────────────────────────────
              const SectionHeader(title: 'Quick Stats')
                  .animate(delay: 100.ms)
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: AppConstants.spaceMD),
              _QuickStats(stats: data.quickStats, isDark: isDark)
                  .animate(delay: 150.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppConstants.spaceLG),

              // ── Continue Learning ──────────────────────────────────────
              if (data.continueLearning.isNotEmpty) ...[
                SectionHeader(
                  title: 'Continue Learning',
                  actionLabel: 'See All',
                  onAction: () {},
                ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                const SizedBox(height: AppConstants.spaceMD),
                ...data.continueLearning.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(
                          bottom: AppConstants.spaceMD),
                      child: _ContinueLearningCard(
                              course: e.value, isDark: isDark)
                          .animate(
                              delay: Duration(
                                  milliseconds: 220 + e.key * 80))
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: 0.1, end: 0),
                    )),
              ],

              // ── Featured Courses ───────────────────────────────────────
              SectionHeader(
                title: 'Featured Courses',
                actionLabel: 'See All',
                onAction: () {},
              ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
              const SizedBox(height: AppConstants.spaceMD),

              SizedBox(
                height: 230,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.featuredCourses.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppConstants.spaceMD),
                  itemBuilder: (context, i) {
                    final course = data.featuredCourses[i];
                    return SizedBox(
                      width: 175,
                      child: _FeaturedCourseCard(
                              course: course, isDark: isDark)
                          .animate(
                              delay:
                                  Duration(milliseconds: 350 + i * 80))
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: 0.2, end: 0),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppConstants.spaceXL),
            ]),
          ),
        ),
      ],
    );
  }
}

// ── Banner Carousel ───────────────────────────────────────────────────────────
class _BannerCarousel extends StatelessWidget {
  final DashboardController ctrl;
  final PageController pageCtrl;
  final DashboardModel data;

  const _BannerCarousel({
    required this.ctrl,
    required this.pageCtrl,
    required this.data,
  });

  static const List<Color> _colors = [
    Color(0xFF6C63FF),
    Color(0xFFFF6584),
    Color(0xFF43A047),
    Color(0xFF0288D1),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 155,
          child: PageView.builder(
            controller: pageCtrl,
            itemCount: data.banners.length,
            onPageChanged: (i) => ctrl.bannerIndex.value = i,
            itemBuilder: (context, i) {
              final banner = data.banners[i];
              final color = _colors[i % _colors.length];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.75)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusXL),
                ),
                padding: const EdgeInsets.all(AppConstants.spaceMD),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(banner.title,
                              style: AppTextStyles.h2
                                  .copyWith(color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(banner.subtitle,
                              style: AppTextStyles.bodySmall.copyWith(
                                color:
                                    Colors.white.withValues(alpha: 0.85),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color:
                                  Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusFull),
                            ),
                            child: Text('Explore →',
                                style: AppTextStyles.labelMedium
                                    .copyWith(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    // Banner SVG image
                    NetworkImageWidget(
                      url: banner.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                      placeholder: const Icon(Icons.local_offer_rounded,
                          color: Colors.white38, size: 56),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppConstants.spaceSM),
        Obx(() => AnimatedSmoothIndicator(
              activeIndex: ctrl.bannerIndex.value,
              count: data.banners.length,
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

// ── Quick Stats ───────────────────────────────────────────────────────────────
class _QuickStats extends StatelessWidget {
  final QuickStats stats;
  final bool isDark;

  const _QuickStats({required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Enrolled',
        '${stats.enrolledCourses}',
        Icons.book_rounded,
        AppColors.primaryGradient
      ),
      (
        'Attendance',
        '${stats.attendancePercentage.toStringAsFixed(1)}%',
        Icons.calendar_today_rounded,
        AppColors.greenGradient
      ),
      (
        'Pending Assignment',
        '${stats.pendingAssignments}',
        Icons.assignment_late_rounded,
        AppColors.orangeGradient
      ),
    ];

    return Row(
      children: items.asMap().entries.map((e) {
        final item = e.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                right: e.key < items.length - 1 ? AppConstants.spaceSM : 0),
            child: Container(
              padding: const EdgeInsets.all(AppConstants.spaceMD),
              decoration: BoxDecoration(
                gradient: item.$4,
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusLG),
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
                  Icon(item.$3, color: Colors.white70, size: 20),
                  const SizedBox(height: 8),
                  Text(item.$2,
                      style:
                          AppTextStyles.h1.copyWith(color: Colors.white)),
                  Text(item.$1,
                      style: AppTextStyles.caption
                          .copyWith(color: Colors.white70)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Continue Learning Card ────────────────────────────────────────────────────
class _ContinueLearningCard extends StatelessWidget {
  final DashboardCourse course;
  final bool isDark;

  const _ContinueLearningCard(
      {required this.course, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final progress = (course.progressPercentage ?? 0) / 100;
    return AppCard(
      onTap: () =>
          Get.toNamed(AppRoutes.courseDetail, arguments: course.id),
      child: Row(
        children: [
          NetworkImageWidget(
            url: course.thumbnailUrl,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            placeholder: Container(
              width: 72,
              height: 72,
              color: AppColors.primary.withValues(alpha: 0.15),
              child: const Icon(Icons.play_circle_outline,
                  color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppConstants.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(course.title,
                    style: AppTextStyles.h3.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(course.teacher.name,
                    style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    )),
                const SizedBox(height: 8),
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: 6,
                  percent: progress.clamp(0.0, 1.0),
                  backgroundColor: isDark
                      ? AppColors.borderDark
                      : AppColors.borderLight,
                  progressColor: AppColors.primary,
                  barRadius:
                      const Radius.circular(AppConstants.radiusFull),
                ),
                const SizedBox(height: 4),
                Text(
                  '${course.progressPercentage?.toStringAsFixed(0) ?? 0}% complete',
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

// ── Featured Course Card ──────────────────────────────────────────────────────
class _FeaturedCourseCard extends StatelessWidget {
  final DashboardCourse course;
  final bool isDark;

  const _FeaturedCourseCard(
      {required this.course, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () =>
          Get.toNamed(AppRoutes.courseDetail, arguments: course.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          NetworkImageWidget(
            url: course.thumbnailUrl,
            height: 110,
            width: double.infinity,
            fit: BoxFit.cover,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppConstants.radiusLG)),
            placeholder: Container(
              height: 110,
              color: AppColors.primary.withValues(alpha: 0.15),
              child: const Icon(Icons.play_circle_outline,
                  color: AppColors.primary, size: 36),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusFull),
                  ),
                  child: Text(course.category.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      )),
                ),
                const SizedBox(height: 5),
                Text(course.title,
                    style: AppTextStyles.h3.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontSize: 12,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text(course.teacher.name,
                    style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                course.isFree
                    ? Text('Free',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.success,
                          fontSize: 13,
                        ))
                    : Row(
                        children: [
                          if (course.salePrice != null) ...[
                            Text('₹${course.salePrice!.toStringAsFixed(0)}',
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                )),
                            const SizedBox(width: 4),
                            Text('₹${course.price.toStringAsFixed(0)}',
                                style: AppTextStyles.caption.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                )),
                          ] else
                            Text('₹${course.price.toStringAsFixed(0)}',
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                )),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
