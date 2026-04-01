import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/network_image_widget.dart';
import '../../core/widgets/shimmer_widgets.dart';
import '../../data/models/exam_api_model.dart';
import 'exam_detail_screen.dart';
import 'exams_controller.dart';

class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ExamsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: Get.back,
          ),
          title: Text('Exams',
              style: AppTextStyles.h2.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              )),
          bottom: TabBar(
            onTap: (i) => ctrl.tabIndex.value = i,
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past Results'),
            ],
          ),
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
                      onPressed: ctrl.fetchAll,
                      child: const Text('Retry')),
                ],
              ),
            );
          }

          return TabBarView(
            children: [
              _ExamList(
                exams: ctrl.upcoming,
                isDark: isDark,
                emptyMsg: 'No upcoming exams',
                emptyIcon: Icons.event_available_rounded,
              ),
              _ExamList(
                exams: ctrl.past,
                isDark: isDark,
                emptyMsg: 'No past results',
                emptyIcon: Icons.history_edu_rounded,
                isPast: true,
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ── Exam List ─────────────────────────────────────────────────────────────────
class _ExamList extends StatelessWidget {
  final List<ExamApiModel> exams;
  final bool isDark;
  final String emptyMsg;
  final IconData emptyIcon;
  final bool isPast;

  const _ExamList({
    required this.exams,
    required this.isDark,
    required this.emptyMsg,
    required this.emptyIcon,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    if (exams.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon,
                    size: 64,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight)
                .animate()
                .scale(
                    begin: const Offset(0.5, 0.5),
                    duration: 500.ms,
                    curve: Curves.elasticOut),
            const SizedBox(height: AppConstants.spaceMD),
            Text(emptyMsg,
                style: AppTextStyles.h3.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                )),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: Get.find<ExamsController>().fetchAll,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppConstants.spaceMD),
        itemCount: exams.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppConstants.spaceMD),
        itemBuilder: (context, i) => (isPast
                ? _PastExamCard(exam: exams[i], isDark: isDark)
                : _UpcomingExamCard(exam: exams[i], isDark: isDark))
            .animate(delay: Duration(milliseconds: i * 60))
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, end: 0),
      ),
    );
  }
}

// ── Upcoming Exam Card ────────────────────────────────────────────────────────
class _UpcomingExamCard extends StatelessWidget {
  final ExamApiModel exam;
  final bool isDark;
  const _UpcomingExamCard({required this.exam, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Get.to(() => ExamDetailScreen(examId: exam.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(exam.title,
                    style: AppTextStyles.h3.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
              _ModeBadge(mode: exam.mode),
            ],
          ),
          const SizedBox(height: 6),
          Text(exam.course.title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: AppConstants.spaceMD),
          // Date + time row
          Row(
            children: [
              _InfoChip(
                icon: Icons.calendar_today_rounded,
                label: exam.examDate,
                color: AppColors.info,
              ),
              const SizedBox(width: AppConstants.spaceSM),
              _InfoChip(
                icon: Icons.access_time_rounded,
                label:
                    '${exam.startTime.substring(0, 5)} – ${exam.endTime.substring(0, 5)}',
                color: AppColors.secondary,
              ),
              const SizedBox(width: AppConstants.spaceSM),
              _InfoChip(
                icon: Icons.timer_rounded,
                label: '${exam.durationMinutes}m',
                color: AppColors.warning,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spaceSM),
          // Teacher
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: ClipOval(
                  child: NetworkImageWidget(
                    url: exam.teacher.avatarUrl,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    placeholder: Text(
                      exam.teacher.name.isNotEmpty
                          ? exam.teacher.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(exam.teacher.name,
                  style: AppTextStyles.caption.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Past Exam Card ────────────────────────────────────────────────────────────
class _PastExamCard extends StatelessWidget {
  final ExamApiModel exam;
  final bool isDark;
  const _PastExamCard({required this.exam, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final result = exam.result;
    final pct = result?.percentage ?? 0;
    final gradeColor = pct >= 75
        ? AppColors.success
        : pct >= 50
            ? AppColors.warning
            : AppColors.error;

    return AppCard(
      onTap: () => Get.to(() => ExamDetailScreen(examId: exam.id)),
      child: Row(
        children: [
          // Grade circle
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: gradeColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: result != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(result.grade,
                            style: AppTextStyles.h2
                                .copyWith(color: gradeColor)),
                        Text('${pct.toStringAsFixed(0)}%',
                            style: AppTextStyles.caption
                                .copyWith(color: gradeColor)),
                      ],
                    )
                  : Icon(Icons.quiz_rounded,
                      color: gradeColor, size: 28),
            ),
          ),
          const SizedBox(width: AppConstants.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exam.title,
                    style: AppTextStyles.h3.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(exam.course.title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 4),
                if (result != null)
                  Text(
                    '${result.marksObtained}/${result.maxMarks} marks',
                    style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                Text(exam.examDate,
                    style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    )),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.textSecondaryLight),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────
class _ModeBadge extends StatelessWidget {
  final String mode;
  const _ModeBadge({required this.mode});

  @override
  Widget build(BuildContext context) {
    final color = mode == 'online'
        ? AppColors.success
        : mode == 'offline'
            ? AppColors.warning
            : AppColors.info;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(mode,
          style: AppTextStyles.caption
              .copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Text(label,
            style: AppTextStyles.caption
                .copyWith(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

