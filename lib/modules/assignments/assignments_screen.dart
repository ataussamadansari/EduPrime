import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/shimmer_widgets.dart';
import '../../data/models/assignment_api_model.dart';
import 'assignment_detail_screen.dart';
import 'assignments_controller.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AssignmentsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: Text('Assignments',
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
                    onPressed: ctrl.fetchAssignments,
                    child: const Text('Retry')),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Filter chips
            _FilterBar(ctrl: ctrl, isDark: isDark)
                .animate()
                .fadeIn(duration: 400.ms),

            // List
            Expanded(
              child: ctrl.filtered.isEmpty
                  ? Center(
                      child: Text('No assignments found',
                          style: AppTextStyles.h3.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          )),
                    )
                  : RefreshIndicator(
                      onRefresh: ctrl.fetchAssignments,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(AppConstants.spaceMD),
                        itemCount: ctrl.filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppConstants.spaceMD),
                        itemBuilder: (context, i) {
                          final a = ctrl.filtered[i];
                          return _AssignmentCard(
                            assignment: a,
                            isDark: isDark,
                          )
                              .animate(
                                  delay: Duration(milliseconds: i * 60))
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: 0.1, end: 0);
                        },
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}

// ── Filter Bar ────────────────────────────────────────────────────────────────
class _FilterBar extends StatelessWidget {
  final AssignmentsController ctrl;
  final bool isDark;
  const _FilterBar({required this.ctrl, required this.isDark});

  static const _filters = [
    ('all', 'All'),
    ('pending', 'Pending'),
    ('submitted', 'Submitted'),
    ('graded', 'Graded'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Obx(() => ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spaceMD, vertical: 4),
            children: _filters.map((f) {
              final isSelected = ctrl.filter.value == f.$1;
              return Padding(
                padding:
                    const EdgeInsets.only(right: AppConstants.spaceSM),
                child: FilterChip(
                  label: Text(f.$2),
                  selected: isSelected,
                  onSelected: (_) => ctrl.setFilter(f.$1),
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
                ),
              );
            }).toList(),
          )),
    );
  }
}

// ── Assignment Card ───────────────────────────────────────────────────────────
class _AssignmentCard extends StatelessWidget {
  final AssignmentApiModel assignment;
  final bool isDark;
  const _AssignmentCard({required this.assignment, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Get.to(
        () => const AssignmentDetailScreen(),
        arguments: assignment.id,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(assignment.title,
                    style: AppTextStyles.h3.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: AppConstants.spaceSM),
              _StatusBadge(assignment: assignment),
            ],
          ),
          const SizedBox(height: 6),
          Text(assignment.course.title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 12,
                  color: assignment.isPastDue
                      ? AppColors.error
                      : (isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight)),
              const SizedBox(width: 4),
              Text(
                'Due: ${_formatDate(assignment.dueAt)}',
                style: AppTextStyles.caption.copyWith(
                  color: assignment.isPastDue
                      ? AppColors.error
                      : (isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight),
                  fontWeight: assignment.isPastDue
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
              const Spacer(),
              Text('${assignment.maxMarks} marks',
                  style: AppTextStyles.caption.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  )),
            ],
          ),
          // Grade if available
          if (assignment.isGraded && assignment.submission?.marks != null) ...[
            const SizedBox(height: AppConstants.spaceSM),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spaceSM, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSM),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.grade_rounded,
                      color: AppColors.success, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${assignment.submission!.marks}/${assignment.maxMarks}',
                    style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.success),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final d = DateTime.parse(iso).toLocal();
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return iso.length >= 10 ? iso.substring(0, 10) : iso;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final AssignmentApiModel assignment;
  const _StatusBadge({required this.assignment});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;
    if (assignment.isGraded) {
      color = AppColors.success;
      label = 'Graded';
    } else if (assignment.isSubmitted) {
      color = AppColors.info;
      label = 'Submitted';
    } else if (assignment.isPastDue) {
      color = AppColors.error;
      label = 'Overdue';
    } else {
      color = AppColors.warning;
      label = 'Pending';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(label,
          style: AppTextStyles.caption
              .copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

