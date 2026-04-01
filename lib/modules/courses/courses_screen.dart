import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_routes.dart';
import '../../core/widgets/course_card.dart';
import 'courses_controller.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late final CoursesController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(CoursesController());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explore Courses',
          style: AppTextStyles.h2.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        actions: [
          // Obx only wraps the icon — no .animate() on it
          Obx(() => IconButton(
                icon: Icon(
                  _ctrl.isGridView.value
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
                onPressed: _ctrl.toggleView,
              )),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search bar ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spaceMD,
              0,
              AppConstants.spaceMD,
              AppConstants.spaceSM,
            ),
            child: TextField(
              onChanged: _ctrl.updateSearch,
              decoration: InputDecoration(
                hintText: 'Search courses, instructors...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                suffixIcon:
                    const Icon(Icons.tune_rounded, color: AppColors.primary),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

          // ── Category chips — GetBuilder, no .animate() wrapper ───────
          SizedBox(
            height: 44,
            child: GetBuilder<CoursesController>(
              builder: (ctrl) => ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spaceMD),
                itemCount: ctrl.categories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppConstants.spaceSM),
                itemBuilder: (context, i) {
                  final cat = ctrl.categories[i];
                  final isSelected = ctrl.selectedCategory.value == cat;
                  return FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => ctrl.selectCategory(cat),
                    backgroundColor:
                        isDark ? AppColors.cardDark : AppColors.surfaceLight,
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    checkmarkColor: AppColors.primary,
                    labelStyle: AppTextStyles.labelMedium.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight),
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusFull),
                    ),
                    showCheckmark: false,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: AppConstants.spaceMD),

          // ── Course grid / list — Expanded + Obx, no .animate() on Obx ─
          Expanded(
            child: GetBuilder<CoursesController>(
              builder: (ctrl) {
                final courses = ctrl.filteredCourses;

                if (courses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                        const SizedBox(height: AppConstants.spaceMD),
                        Text(
                          'No courses found',
                          style: AppTextStyles.h3.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (ctrl.isGridView.value) {
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spaceMD),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: AppConstants.spaceMD,
                      mainAxisSpacing: AppConstants.spaceMD,
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, i) => CourseCard(
                      course: courses[i],
                      onTap: () => Get.toNamed(AppRoutes.courseDetail,
                          arguments: courses[i]),
                    )
                        .animate(delay: Duration(milliseconds: i * 60))
                        .fadeIn(duration: 350.ms)
                        .scale(
                          begin: const Offset(0.92, 0.92),
                          end: const Offset(1, 1),
                          duration: 350.ms,
                        ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spaceMD),
                  itemCount: courses.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppConstants.spaceMD),
                  itemBuilder: (context, i) => CourseCard(
                    course: courses[i],
                    isGrid: false,
                    onTap: () => Get.toNamed(AppRoutes.courseDetail,
                        arguments: courses[i]),
                  )
                      .animate(delay: Duration(milliseconds: i * 60))
                      .fadeIn(duration: 350.ms)
                      .slideX(begin: 0.1, end: 0),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
