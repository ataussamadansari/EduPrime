import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_card.dart';
import '../../data/dummy/dummy_data.dart';
import '../../data/models/exam_model.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final upcoming =
        DummyData.exams.where((e) => e.status == ExamStatus.upcoming).toList();
    final past =
        DummyData.exams.where((e) => e.status == ExamStatus.completed).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exams',
          style: AppTextStyles.h2.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: AppTextStyles.labelLarge,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past Results'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ExamList(exams: upcoming, isDark: isDark, isPast: false),
          _ExamList(exams: past, isDark: isDark, isPast: true),
        ],
      ),
    );
  }
}

class _ExamList extends StatelessWidget {
  final List<ExamModel> exams;
  final bool isDark;
  final bool isPast;

  const _ExamList({
    required this.exams,
    required this.isDark,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    if (exams.isEmpty) {
      return Center(
        child: Text(
          isPast ? 'No past exams' : 'No upcoming exams',
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.spaceMD),
      itemCount: exams.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spaceMD),
      itemBuilder: (context, i) => _ExamCard(
        exam: exams[i],
        isDark: isDark,
        isPast: isPast,
      )
          .animate(delay: Duration(milliseconds: i * 80))
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.1, end: 0),
    );
  }
}

class _ExamCard extends StatelessWidget {
  final ExamModel exam;
  final bool isDark;
  final bool isPast;

  const _ExamCard({
    required this.exam,
    required this.isDark,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    final scorePercent =
        exam.score != null ? exam.score! / exam.totalMarks : 0.0;
    final scoreColor = scorePercent >= 0.75
        ? AppColors.success
        : scorePercent >= 0.5
            ? AppColors.warning
            : AppColors.error;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: isPast
                      ? AppColors.greenGradient
                      : AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                ),
                child: Icon(
                  isPast
                      ? Icons.assignment_turned_in_rounded
                      : Icons.timer_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.title,
                      style: AppTextStyles.h3.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      exam.courseName,
                      style: AppTextStyles.caption.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              if (isPast && exam.score != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: scoreColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${exam.score}',
                        style: AppTextStyles.h2.copyWith(color: scoreColor),
                      ),
                      Text(
                        '/${exam.totalMarks}',
                        style: AppTextStyles.caption.copyWith(
                          color: scoreColor,
                        ),
                      ),
                    ],
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

          // Details row
          Wrap(
            spacing: AppConstants.spaceMD,
            runSpacing: 6,
            children: [
              _InfoChip(
                icon: Icons.calendar_today_rounded,
                label: exam.date,
                isDark: isDark,
              ),
              _InfoChip(
                icon: Icons.access_time_rounded,
                label: exam.time,
                isDark: isDark,
              ),
              _InfoChip(
                icon: Icons.hourglass_empty_rounded,
                label: exam.duration,
                isDark: isDark,
              ),
              _InfoChip(
                icon: Icons.location_on_rounded,
                label: exam.venue,
                isDark: isDark,
              ),
            ],
          ),

          if (!isPast) ...[
            const SizedBox(height: AppConstants.spaceMD),
            Container(
              padding: const EdgeInsets.all(AppConstants.spaceSM),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppConstants.radiusMD),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.primary, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Prepare well. Best of luck! 🎯',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 13,
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
