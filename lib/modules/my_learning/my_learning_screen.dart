import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/dummy/dummy_data.dart';
import '../../data/models/course_model.dart';

class MyLearningScreen extends StatelessWidget {
  const MyLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final enrolled = DummyData.enrolledCourses;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Learning',
          style: AppTextStyles.h2.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ),
      body: enrolled.isEmpty
          ? _EmptyState(isDark: isDark)
          : ListView.separated(
              padding: const EdgeInsets.all(AppConstants.spaceMD),
              itemCount: enrolled.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppConstants.spaceMD),
              itemBuilder: (context, i) => _EnrolledCourseCard(
                course: enrolled[i],
                isDark: isDark,
              )
                  .animate(delay: Duration(milliseconds: i * 80))
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1, end: 0),
            ),
    );
  }
}

class _EnrolledCourseCard extends StatelessWidget {
  final CourseModel course;
  final bool isDark;

  const _EnrolledCourseCard({required this.course, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with progress overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppConstants.radiusLG),
                ),
                child: Image.network(
                  course.thumbnail,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140,
                    color: AppColors.primary.withValues(alpha: 0.15),
                    child: const Icon(Icons.play_circle_outline,
                        color: AppColors.primary, size: 48),
                  ),
                ),
              ),
              // Progress badge
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
                    '${(course.progress * 100).toInt()}% done',
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
                Text(
                  course.title,
                  style: AppTextStyles.h3.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  course.instructor,
                  style: AppTextStyles.caption.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: AppConstants.spaceMD),

                // Progress bar
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: 8,
                  percent: course.progress,
                  backgroundColor:
                      isDark ? AppColors.borderDark : AppColors.borderLight,
                  linearGradient: AppColors.primaryGradient,
                  barRadius: const Radius.circular(AppConstants.radiusFull),
                ),
                const SizedBox(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${course.completedLessons}/${course.totalLessons} lessons',
                      style: AppTextStyles.caption.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    if (course.lastAccessed.isNotEmpty)
                      Text(
                        'Last: ${course.lastAccessed}',
                        style: AppTextStyles.caption.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: AppConstants.spaceMD),

                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label:
                            course.progress > 0 ? 'Continue' : 'Start Learning',
                        onTap: () => Get.toNamed(
                          AppRoutes.courseDetail,
                          arguments: course,
                        ),
                        icon: Icons.play_arrow_rounded,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spaceSM),
                    // Attendance shortcut
                    InkWell(
                      onTap: () {},
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMD),
                      child: Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          ),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMD),
                        ),
                        child: Icon(
                          Icons.calendar_today_rounded,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          size: 20,
                        ),
                      ),
                    ),
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

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ).animate().scale(
              begin: const Offset(0.5, 0.5),
              duration: 500.ms,
              curve: Curves.elasticOut),
          const SizedBox(height: AppConstants.spaceMD),
          Text(
            'No courses yet',
            style: AppTextStyles.h2.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppConstants.spaceSM),
          Text(
            'Enroll in a course to start learning',
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppConstants.spaceLG),
          AppButton(
            label: 'Browse Courses',
            onTap: () {},
            width: 200,
          ),
        ],
      ),
    );
  }
}
