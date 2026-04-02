import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/network_image_widget.dart';
import '../../core/widgets/shimmer_widgets.dart';
import '../../data/models/course_detail_model.dart';
import '../../data/models/review_model.dart';
import 'course_detail_controller.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(CourseDetailController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const CourseDetailShimmer();
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
                  onPressed: () {
                    final id = Get.arguments;
                    if (id is int) ctrl.retry();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        final course = ctrl.course.value;
        if (course == null) return const SizedBox.shrink();
        return _CourseDetailBody(ctrl: ctrl, course: course, isDark: isDark);
      }),
    );
  }
}

class _CourseDetailBody extends StatelessWidget {
  final CourseDetailController ctrl;
  final CourseDetailModel course;
  final bool isDark;

  const _CourseDetailBody({
    required this.ctrl,
    required this.course,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // ── Hero Banner ───────────────────────────────────────────────
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
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    NetworkImageWidget(
                      url: course.thumbnailUrl,
                      fit: BoxFit.cover,
                      placeholder: Container(
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
                            Colors.black.withValues(alpha: 0.65),
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

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.spaceMD,
                AppConstants.spaceMD,
                AppConstants.spaceMD,
                100,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Chips ───────────────────────────────────────────────
                  Wrap(
                    spacing: AppConstants.spaceSM,
                    runSpacing: AppConstants.spaceSM,
                    children: [
                      _Chip(
                          label: course.category.name,
                          color: AppColors.primary),
                      _Chip(
                          label: '⏱ ${course.durationText}',
                          color: AppColors.secondary),
                      _Chip(label: course.level, color: AppColors.success),
                      _Chip(label: course.language, color: AppColors.info),
                    ],
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: AppConstants.spaceMD),

                  // ── Title ───────────────────────────────────────────────
                  Text(course.title,
                      style: AppTextStyles.h1.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      )).animate(delay: 50.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: AppConstants.spaceSM),

                  // ── Subtitle ────────────────────────────────────────────
                  Text(course.subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        height: 1.5,
                      )).animate(delay: 80.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: AppConstants.spaceMD),

                  // ── Teacher ─────────────────────────────────────────────
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.15),
                        child: ClipOval(
                          child: NetworkImageWidget(
                            url: course.teacher.avatarUrl,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            placeholder: Text(
                              course.teacher.name.isNotEmpty
                                  ? course.teacher.name[0].toUpperCase()
                                  : '?',
                              style: AppTextStyles.labelMedium
                                  .copyWith(color: AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spaceSM),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(course.teacher.name,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              )),
                          if (course.teacher.qualification != null)
                            Text(course.teacher.qualification!,
                                style: AppTextStyles.caption.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                )),
                        ],
                      ),
                    ],
                  ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: AppConstants.spaceMD),

                  // ── Rating ──────────────────────────────────────────────
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: course.averageRating,
                        itemBuilder: (_, __) =>
                            const Icon(Icons.star, color: Color(0xFFFFC107)),
                        itemCount: 5,
                        itemSize: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(course.averageRating.toStringAsFixed(1),
                          style: AppTextStyles.labelLarge.copyWith(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          )),
                      const SizedBox(width: 4),
                      Text('(${course.reviewsCount} reviews)',
                          style: AppTextStyles.caption.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          )),
                    ],
                  ).animate(delay: 150.ms).fadeIn(duration: 400.ms),

                  // ── Progress (if enrolled) ──────────────────────────────
                  if (course.isEnrolled &&
                      course.progressPercentage != null) ...[
                    const SizedBox(height: AppConstants.spaceMD),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Your Progress',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                                  )),
                              Text(
                                '${course.progressPercentage!.toStringAsFixed(0)}%',
                                style: AppTextStyles.labelLarge
                                    .copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.spaceSM),
                          LinearPercentIndicator(
                            padding: EdgeInsets.zero,
                            lineHeight: 8,
                            percent: (course.progressPercentage! / 100)
                                .clamp(0.0, 1.0),
                            backgroundColor: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                            progressColor: AppColors.primary,
                            barRadius:
                                const Radius.circular(AppConstants.radiusFull),
                          ),
                        ],
                      ),
                    ).animate(delay: 180.ms).fadeIn(duration: 400.ms),
                  ],

                  const SizedBox(height: AppConstants.spaceLG),
                  Divider(
                      color: isDark
                          ? AppColors.dividerDark
                          : AppColors.dividerLight),
                  const SizedBox(height: AppConstants.spaceMD),

                  // ── Description ─────────────────────────────────────────
                  if (course.description != null &&
                      course.description!.isNotEmpty) ...[
                    Text('About this Course',
                        style: AppTextStyles.h2.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        )).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                    const SizedBox(height: AppConstants.spaceSM),
                    Text(course.description!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          height: 1.6,
                        )).animate(delay: 230.ms).fadeIn(duration: 400.ms),
                    const SizedBox(height: AppConstants.spaceLG),
                  ],

                  // ── Curriculum ──────────────────────────────────────────
                  if (course.curriculum.isNotEmpty ||
                      ctrl.curriculum.isNotEmpty) ...[
                    Text('Curriculum',
                        style: AppTextStyles.h2.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        )).animate(delay: 280.ms).fadeIn(duration: 400.ms),
                    const SizedBox(height: AppConstants.spaceMD),
                    Obx(() {
                      // Prefer dedicated curriculum API, fallback to course.curriculum
                      final sections = ctrl.curriculum.isNotEmpty
                          ? ctrl.curriculum
                              .map((s) => _SectionData(
                                    title: s.title,
                                    lessonCount: s.lessons.length,
                                    lessons: s.lessons
                                        .map((l) => _LessonData(
                                              id: l.id,
                                              title: l.title,
                                              durationText:
                                                  l.durationMinutes > 0
                                                      ? '${l.durationMinutes}m'
                                                      : null,
                                              isCompleted: l.isCompleted,
                                              isLocked: l.isLocked,
                                              isFree: l.isPreview,
                                              onTap: () => ctrl.openLesson(l),
                                            ))
                                        .toList(),
                                  ))
                              .toList()
                          : course.curriculum
                              .map((s) => _SectionData(
                                    title: s.title,
                                    lessonCount: s.lessons.length,
                                    lessons: s.lessons
                                        .map((l) => _LessonData(
                                              id: l.id,
                                              title: l.title,
                                              durationText: l.durationText,
                                              isCompleted: l.isCompleted,
                                              isLocked: l.isLocked,
                                              isFree: l.isFree,
                                            ))
                                        .toList(),
                                  ))
                              .toList();
                      return Column(
                        children: sections.asMap().entries.map((e) {
                          final i = e.key;
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppConstants.spaceSM),
                            child: _CurriculumSection(
                              section: e.value,
                              isExpanded: ctrl.expandedSections.contains(i),
                              isDark: isDark,
                              onToggle: () => ctrl.toggleSection(i),
                            )
                                .animate(
                                    delay: Duration(milliseconds: 300 + i * 60))
                                .fadeIn(duration: 350.ms),
                          );
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: AppConstants.spaceLG),
                  ],

                  // ── Reviews ─────────────────────────────────────────────
                  Obx(() {
                    final reviewList = ctrl.reviews;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Reviews (${reviewList.length})',
                                    style: AppTextStyles.h2.copyWith(
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimaryLight,
                                    ))
                                .animate(delay: 350.ms)
                                .fadeIn(duration: 400.ms),
                            if (course.isEnrolled)
                              TextButton.icon(
                                onPressed: () =>
                                    _showReviewSheet(context, ctrl, isDark),
                                icon: const Icon(Icons.rate_review_rounded,
                                    size: 16),
                                label: const Text('Write Review'),
                              ),
                          ],
                        ),
                        if (reviewList.isNotEmpty) ...[
                          const SizedBox(height: AppConstants.spaceMD),
                          ...reviewList.asMap().entries.map((e) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppConstants.spaceXL),
                                child:
                                    _ReviewCard(review: e.value, isDark: isDark)
                                        .animate(
                                            delay: Duration(
                                                milliseconds: 380 + e.key * 60))
                                        .fadeIn(duration: 350.ms),
                              )),
                        ],
                      ],
                    );
                  }),
                ]),
              ),
            ),
          ],
        ),

        // ── Sticky Bottom CTA ─────────────────────────────────────────────
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              AppConstants.spaceMD,
              AppConstants.spaceMD,
              AppConstants.spaceMD,
              AppConstants.spaceMD + MediaQuery.viewPaddingOf(context).bottom,
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
                    course.isFree
                        ? Text('Free',
                            style: AppTextStyles.h1
                                .copyWith(color: AppColors.success))
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${(course.salePrice ?? course.price).toStringAsFixed(0)}',
                                style: AppTextStyles.h1
                                    .copyWith(color: AppColors.primary),
                              ),
                              if (course.salePrice != null) ...[
                                const SizedBox(width: 6),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    '₹${course.price.toStringAsFixed(0)}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                    Text(
                      course.isEnrolled ? 'Enrolled' : 'One-time payment',
                      style: AppTextStyles.caption.copyWith(
                        color: course.isEnrolled
                            ? AppColors.success
                            : (isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppConstants.spaceMD),
                Expanded(
                  child: Obx(() => AppButton(
                        label: course.isEnrolled
                            ? 'Continue Learning'
                            : 'Enroll Now',
                        onTap: course.isEnrolled
                            ? ctrl.continueLearning
                            : ctrl.enroll,
                        isLoading: ctrl.isEnrolling.value,
                        icon: course.isEnrolled
                            ? Icons.play_arrow_rounded
                            : Icons.school_rounded,
                      )),
                ),
              ],
            ),
          )
              .animate()
              .slideY(begin: 0.3, end: 0, duration: 400.ms)
              .fadeIn(duration: 400.ms),
        ),
      ],
    );
  }
}

void _showReviewSheet(
    BuildContext context, CourseDetailController ctrl, bool isDark) {
  Get.bottomSheet(
    Container(
      padding: EdgeInsets.only(
        left: AppConstants.spaceMD,
        right: AppConstants.spaceMD,
        top: AppConstants.spaceMD,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppConstants.spaceLG,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusXL)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spaceMD),
            Text('Write a Review',
                style: AppTextStyles.h2.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                )),
            const SizedBox(height: AppConstants.spaceMD),
            // Star rating
            Obx(() => RatingBar.builder(
                  initialRating: ctrl.reviewRating.value.toDouble(),
                  minRating: 1,
                  itemCount: 5,
                  itemSize: 36,
                  itemBuilder: (_, __) =>
                      const Icon(Icons.star, color: Color(0xFFFFC107)),
                  onRatingUpdate: (r) => ctrl.reviewRating.value = r.toInt(),
                )),
            const SizedBox(height: AppConstants.spaceMD),
            TextField(
              controller: ctrl.reviewTitleCtrl,
              decoration: const InputDecoration(
                hintText: 'Review title',
                prefixIcon: Icon(Icons.title_rounded),
              ),
            ),
            const SizedBox(height: AppConstants.spaceMD),
            TextField(
              controller: ctrl.reviewBodyCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Share your experience...',
                prefixIcon: Icon(Icons.rate_review_outlined),
              ),
            ),
            const SizedBox(height: AppConstants.spaceLG),
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: ctrl.isSubmittingReview.value
                        ? null
                        : ctrl.submitReview,
                    child: ctrl.isSubmittingReview.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Submit Review'),
                  ),
                )),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

// ── Chip ──────────────────────────────────────────────────────────────────────
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
      child: Text(label,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          )),
    );
  }
}

// ── Section/Lesson data wrappers ──────────────────────────────────────────────
class _SectionData {
  final String title;
  final int lessonCount;
  final List<_LessonData> lessons;
  const _SectionData(
      {required this.title, required this.lessonCount, required this.lessons});
}

class _LessonData {
  final int id;
  final String title;
  final String? durationText;
  final bool isCompleted;
  final bool isLocked;
  final bool isFree;
  final VoidCallback? onTap;
  const _LessonData({
    required this.id,
    required this.title,
    this.durationText,
    required this.isCompleted,
    required this.isLocked,
    required this.isFree,
    this.onTap,
  });
}

// ── Curriculum Section ────────────────────────────────────────────────────────
class _CurriculumSection extends StatelessWidget {
  final _SectionData section;
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
                    child: Text(section.title,
                        style: AppTextStyles.h3.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        )),
                  ),
                  Text('${section.lessonCount} lessons',
                      style: AppTextStyles.caption.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      )),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: AppConstants.animFast,
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight),
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
                    color: isDark
                        ? AppColors.dividerDark
                        : AppColors.dividerLight),
                ...section.lessons
                    .map((l) => _LessonTile(lesson: l, isDark: isDark)),
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

// ── Lesson Tile ───────────────────────────────────────────────────────────────
class _LessonTile extends StatelessWidget {
  final _LessonData lesson;
  final bool isDark;
  const _LessonTile({required this.lesson, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: lesson.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceMD, vertical: AppConstants.spaceSM),
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
              child: Text(lesson.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: lesson.isLocked
                        ? (isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight)
                        : (isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight),
                  )),
            ),
            if (lesson.durationText != null)
              Text(lesson.durationText!,
                  style: AppTextStyles.caption.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  )),
            if (lesson.isFree && !lesson.isLocked) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                ),
                child: Text('Free',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    )),
              ),
            ],
          ],
        ), // Row
      ), // Padding (child of InkWell)
    ); // InkWell
  }
}

// ── Review Card ───────────────────────────────────────────────────────────────
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
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: ClipOval(
              child: NetworkImageWidget(
                url: review.student.avatarUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                placeholder: Text(
                  review.student.name.isNotEmpty
                      ? review.student.name[0].toUpperCase()
                      : '?',
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(review.student.name,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        )),
                    Text(
                        review.createdAt.length >= 10
                            ? review.createdAt.substring(0, 10)
                            : review.createdAt,
                        style: AppTextStyles.caption.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        )),
                  ],
                ),
                const SizedBox(height: 4),
                RatingBarIndicator(
                  rating: review.rating.toDouble(),
                  itemBuilder: (_, __) =>
                      const Icon(Icons.star, color: Color(0xFFFFC107)),
                  itemCount: 5,
                  itemSize: 14,
                ),
                if (review.title != null && review.title!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(review.title!,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      )),
                ],
                if (review.review != null && review.review!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(review.review!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        height: 1.5,
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
