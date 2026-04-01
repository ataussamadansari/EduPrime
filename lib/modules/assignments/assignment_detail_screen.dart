import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/models/assignment_api_model.dart';
import 'assignments_controller.dart';
class AssignmentDetailScreen extends StatelessWidget {
  const AssignmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AssignmentDetailController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: Text('Assignment',
            style: AppTextStyles.h2.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            )),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
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
                    onPressed: ctrl.retry,
                    child: const Text('Retry')),
              ],
            ),
          );
        }
        final a = ctrl.assignment.value;
        if (a == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Text(a.title,
                      style: AppTextStyles.h1.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ))
                  .animate()
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: 6),
              Text(a.course.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: AppConstants.spaceMD),

              // Meta row
              Wrap(
                spacing: AppConstants.spaceSM,
                runSpacing: AppConstants.spaceSM,
                children: [
                  _Chip(
                    icon: Icons.calendar_today_rounded,
                    label: 'Due: ${_fmt(a.dueAt)}',
                    color: a.isPastDue ? AppColors.error : AppColors.warning,
                  ),
                  _Chip(
                    icon: Icons.grade_rounded,
                    label: '${a.maxMarks} marks',
                    color: AppColors.primary,
                  ),
                  _Chip(
                    icon: Icons.upload_file_rounded,
                    label: a.submissionType,
                    color: AppColors.secondary,
                  ),
                ],
              ).animate(delay: 60.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceLG),

              // Description
              if (a.description != null) ...[
                _sectionTitle('Description', isDark),
                const SizedBox(height: AppConstants.spaceSM),
                Text(a.description!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      height: 1.6,
                    )),
                const SizedBox(height: AppConstants.spaceLG),
              ],

              // Instructions
              if (a.instructions != null) ...[
                _sectionTitle('Instructions', isDark),
                const SizedBox(height: AppConstants.spaceSM),
                AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: AppColors.info, size: 18),
                      const SizedBox(width: AppConstants.spaceSM),
                      Expanded(
                        child: Text(a.instructions!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              height: 1.5,
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spaceLG),
              ],

              // ── Submission section ───────────────────────────────────────
              _sectionTitle('Submission', isDark),
              const SizedBox(height: AppConstants.spaceMD),

              if (a.isGraded) ...[
                // Graded result
                _GradeCard(
                    submission: a.submission!, maxMarks: a.maxMarks, isDark: isDark)
                    .animate(delay: 100.ms)
                    .fadeIn(duration: 400.ms),
              ] else if (a.isSubmitted) ...[
                // Submitted, awaiting grade
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.hourglass_top_rounded,
                              color: AppColors.info, size: 18),
                          const SizedBox(width: 8),
                          Text('Submitted — Awaiting Grade',
                              style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.info)),
                        ],
                      ),
                      if (a.submission?.submittedAt != null) ...[
                        const SizedBox(height: 6),
                        Text('Submitted on: ${_fmt(a.submission!.submittedAt!)}',
                            style: AppTextStyles.caption.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            )),
                      ],
                      if (a.submission?.submissionText != null) ...[
                        const SizedBox(height: AppConstants.spaceSM),
                        Text(a.submission!.submissionText!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            )),
                      ],
                    ],
                  ),
                ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
              ] else if (a.isPastDue) ...[
                // Overdue
                AppCard(
                  child: Row(
                    children: [
                      const Icon(Icons.warning_rounded,
                          color: AppColors.error, size: 18),
                      const SizedBox(width: 8),
                      Text('Deadline has passed',
                          style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.error)),
                    ],
                  ),
                ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
              ] else ...[
                // Submit form
                _SubmitForm(ctrl: ctrl, isDark: isDark)
                    .animate(delay: 100.ms)
                    .fadeIn(duration: 400.ms),
              ],

              const SizedBox(height: AppConstants.spaceXL),
            ],
          ),
        );
      }),
    );
  }

  String _fmt(String iso) {
    try {
      final d = DateTime.parse(iso).toLocal();
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return iso.length >= 10 ? iso.substring(0, 10) : iso;
    }
  }
}

Widget _sectionTitle(String title, bool isDark) => Text(title,
    style: AppTextStyles.h2.copyWith(
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
    ));

// ── Grade Card ────────────────────────────────────────────────────────────────
class _GradeCard extends StatelessWidget {
  final AssignmentSubmission submission;
  final int maxMarks;
  final bool isDark;
  const _GradeCard(
      {required this.submission,
      required this.maxMarks,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    final pct = submission.marks != null
        ? (submission.marks! / maxMarks * 100).toInt()
        : 0;
    final color = pct >= 75
        ? AppColors.success
        : pct >= 50
            ? AppColors.warning
            : AppColors.error;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('$pct%',
                      style: AppTextStyles.h2.copyWith(color: color)),
                ),
              ),
              const SizedBox(width: AppConstants.spaceMD),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${submission.marks}/$maxMarks marks',
                      style: AppTextStyles.h3.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      )),
                  Text('Graded',
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          if (submission.remarks != null &&
              submission.remarks!.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spaceMD),
            Container(
              padding: const EdgeInsets.all(AppConstants.spaceSM),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.08),
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSM),
                border: Border.all(
                    color: AppColors.info.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.comment_rounded,
                      color: AppColors.info, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(submission.remarks!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Submit Form ───────────────────────────────────────────────────────────────
class _SubmitForm extends StatelessWidget {
  final AssignmentDetailController ctrl;
  final bool isDark;
  const _SubmitForm({required this.ctrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: ctrl.submissionTextCtrl,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Write your answer or notes here...',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spaceMD),

        // File picker
        Obx(() {
          final hasFile = ctrl.pickedFileName.value.isNotEmpty;
          return hasFile
              ? AppCard(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spaceMD,
                      vertical: AppConstants.spaceSM),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_file_rounded,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(ctrl.pickedFileName.value,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            size: 16, color: AppColors.error),
                        onPressed: ctrl.clearFile,
                      ),
                    ],
                  ),
                )
              : OutlinedButton.icon(
                  onPressed: ctrl.pickFile,
                  icon: const Icon(Icons.attach_file_rounded, size: 18),
                  label: const Text('Attach File (PDF/DOC/Image)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMD),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                );
        }),

        const SizedBox(height: AppConstants.spaceLG),
        Obx(() => AppButton(
              label: 'Submit Assignment',
              onTap: ctrl.submit,
              isLoading: ctrl.isSubmitting.value,
              icon: Icons.send_rounded,
            )),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Chip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: AppTextStyles.caption
                  .copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

