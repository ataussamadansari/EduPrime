import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_routes.dart';
import '../../core/widgets/network_image_widget.dart';
import '../../core/widgets/shimmer_widgets.dart';
import '../../data/models/course_category_model.dart';
import '../../data/models/dashboard_model.dart';
import 'courses_controller.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late final CoursesController _ctrl;
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(CoursesController());
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >=
          _scrollCtrl.position.maxScrollExtent - 200) {
        _ctrl.loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Courses',
            style: AppTextStyles.h2.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            )),
        actions: [
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
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(AppConstants.spaceMD, 0,
                AppConstants.spaceMD, AppConstants.spaceSM),
            child: TextField(
              onChanged: _ctrl.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search courses...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                prefixIcon: Icon(Icons.search_rounded,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
                suffixIcon: const Icon(Icons.tune_rounded,
                    color: AppColors.primary),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

          // Category chips
          Obx(() {
            if (_ctrl.categories.isEmpty) return const SizedBox(height: 44);
            return SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spaceMD),
                itemCount: _ctrl.categories.length + 1,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppConstants.spaceSM),
                itemBuilder: (context, i) {
                  final isAll = i == 0;
                  final CourseCategoryModel? cat =
                      isAll ? null : _ctrl.categories[i - 1];
                  final isSelected = isAll
                      ? _ctrl.selectedCategory.value == null
                      : _ctrl.selectedCategory.value?.id == cat?.id;
                  return FilterChip(
                    label: Text(isAll ? 'All' : cat!.name),
                    selected: isSelected,
                    onSelected: (_) => _ctrl.selectCategory(cat),
                    backgroundColor:
                        isDark ? AppColors.cardDark : AppColors.surfaceLight,
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
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
            );
          }),

          const SizedBox(height: AppConstants.spaceMD),

          // Course list
          Expanded(
            child: Obx(() {
              if (_ctrl.isLoading.value) {
                return Obx(() => _ctrl.isGridView.value
                    ? const CourseListShimmer(isGrid: true)
                    : const CourseListShimmer(isGrid: false));
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
                          onPressed: _ctrl.retry,
                          child: const Text('Retry')),
                    ],
                  ),
                );
              }
              if (_ctrl.courses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 64,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight),
                      const SizedBox(height: AppConstants.spaceMD),
                      Text('No courses found',
                          style: AppTextStyles.h3.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          )),
                    ],
                  ),
                );
              }
              return _ctrl.isGridView.value
                  ? _buildGrid(isDark)
                  : _buildList(isDark);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(bool isDark) {
    return GridView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceMD),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: AppConstants.spaceMD,
        mainAxisSpacing: AppConstants.spaceMD,
      ),
      itemCount: _ctrl.courses.length + (_ctrl.hasNextPage ? 1 : 0),
      itemBuilder: (context, i) {
        if (i == _ctrl.courses.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return _CourseCard(
                course: _ctrl.courses[i], isDark: isDark, isGrid: true)
            .animate(delay: Duration(milliseconds: i * 50))
            .fadeIn(duration: 350.ms)
            .scale(
                begin: const Offset(0.92, 0.92),
                end: const Offset(1, 1),
                duration: 350.ms);
      },
    );
  }

  Widget _buildList(bool isDark) {
    return ListView.separated(
      controller: _scrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceMD),
      itemCount: _ctrl.courses.length + (_ctrl.hasNextPage ? 1 : 0),
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppConstants.spaceMD),
      itemBuilder: (context, i) {
        if (i == _ctrl.courses.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return _CourseCard(
                course: _ctrl.courses[i], isDark: isDark, isGrid: false)
            .animate(delay: Duration(milliseconds: i * 50))
            .fadeIn(duration: 350.ms)
            .slideX(begin: 0.1, end: 0);
      },
    );
  }
}

class _CourseCard extends StatelessWidget {
  final DashboardCourse course;
  final bool isDark;
  final bool isGrid;
  const _CourseCard(
      {required this.course, required this.isDark, required this.isGrid});

  void _onTap() => Get.toNamed(AppRoutes.courseDetail, arguments: course.id);

  @override
  Widget build(BuildContext context) =>
      isGrid ? _grid(context) : _list(context);

  Widget _grid(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
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
                  _CategoryChip(name: course.category.name),
                  const SizedBox(height: 5),
                  Text(course.title,
                      style: AppTextStyles.h3.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          fontSize: 12,
                          height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(course.teacher.name,
                      style: AppTextStyles.caption.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  Row(children: [
                    const Icon(Icons.star,
                        color: Color(0xFFFFC107), size: 11),
                    const SizedBox(width: 3),
                    Text(course.averageRating.toStringAsFixed(1),
                        style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight)),
                  ]),
                  const SizedBox(height: 5),
                  _PriceWidget(course: course, isDark: isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            NetworkImageWidget(
              url: course.thumbnailUrl,
              width: 110,
              height: 90,
              fit: BoxFit.cover,
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(AppConstants.radiusLG)),
              placeholder: Container(
                width: 110,
                height: 90,
                color: AppColors.primary.withValues(alpha: 0.15),
                child: const Icon(Icons.play_circle_outline,
                    color: AppColors.primary, size: 32),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spaceSM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(course.title,
                        style: AppTextStyles.h3.copyWith(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                            fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Text(course.teacher.name,
                        style: AppTextStyles.caption.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const Icon(Icons.star,
                              color: Color(0xFFFFC107), size: 13),
                          const SizedBox(width: 3),
                          Text(course.averageRating.toStringAsFixed(1),
                              style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight)),
                        ]),
                        _PriceWidget(course: course, isDark: isDark),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String name;
  const _CategoryChip({required this.name});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        ),
        child: Text(name,
            style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 10)),
      );
}

class _PriceWidget extends StatelessWidget {
  final DashboardCourse course;
  final bool isDark;
  const _PriceWidget({required this.course, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (course.isFree) {
      return Text('Free',
          style: AppTextStyles.labelMedium
              .copyWith(color: AppColors.success, fontSize: 13));
    }
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text('₹${(course.salePrice ?? course.price).toStringAsFixed(0)}',
          style: AppTextStyles.labelMedium
              .copyWith(color: AppColors.primary, fontSize: 13)),
      if (course.salePrice != null) ...[
        const SizedBox(width: 4),
        Text('₹${course.price.toStringAsFixed(0)}',
            style: AppTextStyles.caption.copyWith(
                decoration: TextDecoration.lineThrough,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight)),
      ],
    ]);
  }
}
