import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../home/home_controller.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/network_image_widget.dart';
import '../../core/widgets/shimmer_widgets.dart';
import '../../data/models/dashboard_model.dart';
import 'my_learning_controller.dart';

class MyLearningScreen extends StatelessWidget {
  const MyLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(MyLearningController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Learning',
            style: AppTextStyles.h2.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            )),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const ListShimmer();
        }
        if (ctrl.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(ctrl.error.value,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.error),
                    textAlign: TextAlign.center),
                const SizedBox(height: AppConstants.spaceMD),
                TextButton(
                    onPressed: ctrl.fetchMyCourses, child: const Text('Retry')),
              ],
            ),
          );
        }
        if (ctrl.courses.isEmpty) return _EmptyState(isDark: isDark);

        return RefreshIndicator(
          onRefresh: ctrl.fetchMyCourses,
          child: ListView.separated(
            padding: const EdgeInsets.all(AppConstants.spaceMD),
            itemCount: ctrl.courses.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppConstants.spaceMD),
            itemBuilder: (context, i) => _EnrolledCourseCard(
              course: ctrl.courses[i],
              isDark: isDark,
            )
                .animate(delay: Duration(milliseconds: i * 80))
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
          ),
        );
      }),
    );
  }
}

class _EnrolledCourseCard extends StatelessWidget {
  final DashboardCourse course;
  final bool isDark;

  const _EnrolledCourseCard({required this.course, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final progress = (course.progressPercentage ?? 0) / 100;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              NetworkImageWidget(
                url: course.thumbnailUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppConstants.radiusLG)),
                placeholder: Container(
                  height: 140,
                  color: AppColors.primary.withValues(alpha: 0.15),
                  child: const Icon(Icons.play_circle_outline,
                      color: AppColors.primary, size: 48),
                ),
              ),
              Positioned(
                top: AppConstants.spaceSM,
                right: AppConstants.spaceSM,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusFull),
                  ),
                  child: Text(
                    '${course.progressPercentage?.toStringAsFixed(0) ?? 0}% done',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.spaceMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course.title,
                    style: AppTextStyles.h3.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(course.teacher.name,
                    style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    )),
                const SizedBox(height: AppConstants.spaceMD),
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: 8,
                  percent: progress.clamp(0.0, 1.0),
                  backgroundColor:
                      isDark ? AppColors.borderDark : AppColors.borderLight,
                  linearGradient: AppColors.primaryGradient,
                  barRadius: const Radius.circular(AppConstants.radiusFull),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(course.category.name,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        )),
                    Text(course.durationText,
                        style: AppTextStyles.caption.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        )),
                  ],
                ),
                const SizedBox(height: AppConstants.spaceMD),
                AppButton(
                  label: (course.progressPercentage ?? 0) > 0
                      ? 'Continue'
                      : 'Start Learning',
                  onTap: () =>
                      Get.toNamed(AppRoutes.courseDetail, arguments: course.id),
                  icon: Icons.play_arrow_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school_outlined,
                  size: 80,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight)
              .animate()
              .scale(
                  begin: const Offset(0.5, 0.5),
                  duration: 500.ms,
                  curve: Curves.elasticOut),
          const SizedBox(height: AppConstants.spaceMD),
          Text('No courses yet',
              style: AppTextStyles.h2.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              )),
          const SizedBox(height: AppConstants.spaceSM),
          Text('Enroll in a course to start learning',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              )),
          const SizedBox(height: AppConstants.spaceLG),
          AppButton(
            label: 'Browse Courses',
            onTap: () => Get.find<HomeController>().changePage(1),
            width: 200,
          ),
        ],
      ),
    );
  }
}
