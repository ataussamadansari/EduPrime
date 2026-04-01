import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_card.dart';
import '../../data/dummy/dummy_data.dart';
import '../../data/models/assignment_model.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final assignments = DummyData.assignments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assignments',
          style: AppTextStyles.h2.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppConstants.spaceMD),
        itemCount: assignments.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppConstants.spaceMD),
        itemBuilder: (context, i) => _AssignmentCard(
          assignment: assignments[i],
          isDark: isDark,
        )
            .animate(delay: Duration(milliseconds: i * 80))
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, end: 0),
      ),
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  final AssignmentModel assignment;
  final bool isDark;

  const _AssignmentCard({required this.assignment, required this.isDark});

  Color get _statusColor {
    switch (assignment.status) {
      case AssignmentStatus.pending:
        return AppColors.warning;
      case AssignmentStatus.submitted:
        return AppColors.info;
      case AssignmentStatus.graded:
        return AppColors.success;
      case AssignmentStatus.overdue:
        return AppColors.error;
    }
  }

  String get _statusLabel {
    switch (assignment.status) {
      case AssignmentStatus.pending:
        return 'Pending';
      case AssignmentStatus.submitted:
        return 'Submitted';
      case AssignmentStatus.graded:
        return 'Graded';
      case AssignmentStatus.overdue:
        return 'Overdue';
    }
  }

  IconData get _statusIcon {
    switch (assignment.status) {
      case AssignmentStatus.pending:
        return Icons.pending_actions_rounded;
      case AssignmentStatus.submitted:
        return Icons.upload_file_rounded;
      case AssignmentStatus.graded:
        return Icons.grade_rounded;
      case AssignmentStatus.overdue:
        return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                ),
                child: Icon(_statusIcon, color: _statusColor, size: 22),
              ),
              const SizedBox(width: AppConstants.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.title,
                      style: AppTextStyles.h3.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      assignment.courseName,
                      style: AppTextStyles.caption.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                ),
                child: Text(
                  _statusLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: _statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spaceMD),
          Divider(
            height: 1,
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
          const SizedBox(height: AppConstants.spaceSM),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              const SizedBox(width: 4),
              Text(
                'Due: ${assignment.dueDate}',
                style: AppTextStyles.caption.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const Spacer(),
              if (assignment.status == AssignmentStatus.graded &&
                  assignment.score != null) ...[
                const Icon(Icons.star_rounded,
                    size: 14, color: AppColors.warning),
                const SizedBox(width: 4),
                Text(
                  '${assignment.score}/${assignment.totalMarks}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ] else ...[
                Text(
                  'Max: ${assignment.totalMarks} marks',
                  style: AppTextStyles.caption.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ],
          ),
          if (assignment.status == AssignmentStatus.pending) ...[
            const SizedBox(height: AppConstants.spaceMD),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_rounded, size: 16),
              label: const Text('Submit Assignment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                ),
                textStyle: AppTextStyles.labelLarge,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
