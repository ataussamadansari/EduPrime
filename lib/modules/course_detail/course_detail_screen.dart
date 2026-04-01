import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/models/course_model.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final Set<int> _expandedSections = {0};

  @override
  Widget build(BuildContext context) {
    final course = Get.arguments as CourseModel;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Hero banner
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 16),
                  ),
                  onPressed: Get.back,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'course_thumb_${course.id}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          course.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            child: const Icon(Icons.play_circle_outline,
                                color: AppColors.primary, size: 64),
                          ),
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.6),
                              ],
                            ),
                          ),
                        ),
                        // Play button
                        Center(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow_rounded,
                                color: AppColors.primary, size: 36),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.spaceMD,
                  AppConstants.spaceMD,
                  AppConstants.spaceMD,
                  100, // space for sticky button
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Category + Duration
                    Row(
                      children: [
                        _Chip(label: course.category, color: AppColors.primary),
                        const SizedBox(width: AppConstants.spaceSM),
                        _Chip(
                          label: '⏱ ${course.duration}',
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: AppConstants.spaceSM),
                        _Chip(
                          label: '${course.totalLessons} lessons',
                          color: AppColors.success,
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms),

                    const SizedBox(height: AppConstants.spaceMD),

                    // Title
                    Text(
                      course.title,
                      style: AppTextStyles.h1.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ).animate(delay: 50.ms).fadeIn(duration: 400.ms),

                    const SizedBox(height: AppConstants.spaceSM),

                    // Instructor
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundImage:
                              NetworkImage('https://i.pravatar.cc/60?img=20'),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          course.instructor,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

                    const SizedBox(height: AppConstants.spaceMD),

                    // Rating row
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: course.rating,
                          itemBuilder: (_, __) =>
                              const Icon(Icons.star, color: Color(0xFFFFC107)),
                          itemCount: 5,
                          itemSize: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${course.rating}',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${_formatCount(course.reviewCount)} reviews)',
                          style: AppTextStyles.caption.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ).animate(delay: 150.ms).fadeIn(duration: 400.ms),

                    const SizedBox(height: AppConstants.spaceLG),
                    Divider(
                      color: isDark
                          ? AppColors.dividerDark
                          : AppColors.dividerLight,
                    ),
                    const SizedBox(height: AppConstants.spaceMD),

                    // Description
                    Text(
                      'About this Course',
                      style: AppTextStyles.h2.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                    const SizedBox(height: AppConstants.spaceSM),
                    Text(
                      course.description,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        height: 1.6,
                      ),
                    ).animate(delay: 250.ms).fadeIn(duration: 400.ms),

                    const SizedBox(height: AppConstants.spaceLG),

                    // Curriculum
                    Text(
                      'Curriculum',
                      style: AppTextStyles.h2.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
                    const SizedBox(height: AppConstants.spaceMD),
                    ...course.curriculum.asMap().entries.map((e) {
                      final i = e.key;
                      final section = e.value;
                      final isExpanded = _expandedSections.contains(i);
                      return _CurriculumSection(
                        section: section,
                        isExpanded: isExpanded,
                        isDark: isDark,
                        onToggle: () => setState(() {
                          if (isExpanded) {
                            _expandedSections.remove(i);
                          } else {
                            _expandedSections.add(i);
                          }
                        }),
                      )
                          .animate(delay: Duration(milliseconds: 350 + i * 60))
                          .fadeIn(duration: 350.ms);
                    }),

                    const SizedBox(height: AppConstants.spaceLG),

                    // Reviews
                    if (course.reviews.isNotEmpty) ...[
                      Text(
                        'Student Reviews',
                        style: AppTextStyles.h2.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
                      const SizedBox(height: AppConstants.spaceMD),
                      ...course.reviews.map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppConstants.spaceMD),
                          child: _ReviewCard(review: r, isDark: isDark),
                        ),
                      ),
                    ],
                  ]),
                ),
              ),
            ],
          ),

          // Sticky bottom CTA
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.spaceMD,
                AppConstants.spaceMD,
                AppConstants.spaceMD,
                AppConstants.spaceLG,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.bgDark : AppColors.bgLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '₹${course.price.toStringAsFixed(0)}',
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'One-time payment',
                        style: AppTextStyles.caption.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppConstants.spaceMD),
                  Expanded(
                    child: AppButton(
                      label: course.isEnrolled
                          ? 'Continue Learning'
                          : 'Enroll Now',
                      onTap: () => Get.toNamed(
                        AppRoutes.admission,
                        arguments: course,
                      ),
                      icon: course.isEnrolled
                          ? Icons.play_arrow_rounded
                          : Icons.school_rounded,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .slideY(begin: 0.3, end: 0, duration: 400.ms)
                .fadeIn(duration: 400.ms),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return '$count';
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CurriculumSection extends StatelessWidget {
  final CurriculumSection section;
  final bool isExpanded;
  final bool isDark;
  final VoidCallback onToggle;

  const _CurriculumSection({
    required this.section,
    required this.isExpanded,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(AppConstants.radiusLG),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spaceMD),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      section.title,
                      style: AppTextStyles.h3.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                  Text(
                    '${section.lessons.length} lessons',
                    style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: AppConstants.animFast,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                Divider(
                  height: 1,
                  color:
                      isDark ? AppColors.dividerDark : AppColors.dividerLight,
                ),
                ...section.lessons.map(
                  (lesson) => _LessonTile(lesson: lesson, isDark: isDark),
                ),
              ],
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: AppConstants.animFast,
          ),
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final LessonModel lesson;
  final bool isDark;

  const _LessonTile({required this.lesson, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spaceMD,
        vertical: AppConstants.spaceSM,
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: lesson.isCompleted
                  ? AppColors.success.withValues(alpha: 0.15)
                  : lesson.isLocked
                      ? AppColors.textSecondaryLight.withValues(alpha: 0.1)
                      : AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              lesson.isCompleted
                  ? Icons.check_rounded
                  : lesson.isLocked
                      ? Icons.lock_outline_rounded
                      : Icons.play_arrow_rounded,
              size: 14,
              color: lesson.isCompleted
                  ? AppColors.success
                  : lesson.isLocked
                      ? (isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight)
                      : AppColors.primary,
            ),
          ),
          const SizedBox(width: AppConstants.spaceSM),
          Expanded(
            child: Text(
              lesson.title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: lesson.isLocked
                    ? (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight)
                    : (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
              ),
            ),
          ),
          Text(
            lesson.duration,
            style: AppTextStyles.caption.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final bool isDark;

  const _ReviewCard({required this.review, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(review.avatar),
          ),
          const SizedBox(width: AppConstants.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.name,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      review.date,
                      style: AppTextStyles.caption.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                RatingBarIndicator(
                  rating: review.rating,
                  itemBuilder: (_, __) =>
                      const Icon(Icons.star, color: Color(0xFFFFC107)),
                  itemCount: 5,
                  itemSize: 14,
                ),
                const SizedBox(height: 6),
                Text(
                  review.comment,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
