import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/shimmer_widgets.dart';
import '../../data/models/attendance_model.dart';
import 'attendance_controller.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AttendanceController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: Text('Attendance',
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
                  onPressed: () => ctrl.onMonthChanged(ctrl.focusedMonth.value),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spaceMD),
          child: Column(
            children: [
              // ── Summary ─────────────────────────────────────────────────
              _SummarySection(ctrl: ctrl, isDark: isDark)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.1, end: 0),

              const SizedBox(height: AppConstants.spaceLG),

              // ── Calendar ─────────────────────────────────────────────────
              AppCard(
                child: Obx(() => TableCalendar(
                      firstDay: DateTime(2025, 1, 1),
                      lastDay: DateTime(2027, 12, 31),
                      focusedDay: ctrl.focusedMonth.value,
                      selectedDayPredicate: (day) =>
                          isSameDay(ctrl.selectedDay.value, day),
                      onDaySelected: (selected, focused) {
                        ctrl.onDaySelected(selected);
                      },
                      onPageChanged: ctrl.onMonthChanged,
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        defaultTextStyle: AppTextStyles.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                        weekendTextStyle: AppTextStyles.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                        selectedDecoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: AppTextStyles.h3.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                        leftChevronIcon: Icon(Icons.chevron_left_rounded,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight),
                        rightChevronIcon: Icon(Icons.chevron_right_rounded,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: AppTextStyles.caption.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                        weekendStyle: AppTextStyles.caption.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, _) {
                          final status = ctrl.statusForDay(day);
                          if (status == null) return null;
                          return Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: status
                                  ? AppColors.success.withValues(alpha: 0.15)
                                  : AppColors.error.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: status
                                      ? AppColors.success
                                      : AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )),
              ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceMD),

              // ── Legend ───────────────────────────────────────────────────
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Legend(color: AppColors.success, label: 'Present'),
                  SizedBox(width: AppConstants.spaceLG),
                  _Legend(color: AppColors.error, label: 'Absent'),
                ],
              ).animate(delay: 150.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceLG),

              // ── Selected day detail ──────────────────────────────────────
              Obx(() {
                final day = ctrl.selectedDay.value;
                if (day == null) return const SizedBox.shrink();
                final recs = ctrl.recordsForDay(day);
                if (recs.isEmpty) return const SizedBox.shrink();
                return _DayDetail(day: day, records: recs, isDark: isDark)
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: 0.1, end: 0);
              }),

              const SizedBox(height: AppConstants.spaceXL),
            ],
          ),
        );
      }),
    );
  }
}

// ── Summary Section ───────────────────────────────────────────────────────────
class _SummarySection extends StatelessWidget {
  final AttendanceController ctrl;
  final bool isDark;
  const _SummarySection({required this.ctrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final s = ctrl.summary.value;
    if (s == null) return const SizedBox.shrink();

    return Row(
      children: [
        // Circular progress
        Expanded(
          flex: 2,
          child: AppCard(
            child: Column(
              children: [
                CircularPercentIndicator(
                  radius: 52,
                  lineWidth: 10,
                  percent: (s.attendancePercentage / 100).clamp(0.0, 1.0),
                  center: Text(
                    '${s.attendancePercentage.toStringAsFixed(1)}%',
                    style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                  ),
                  progressColor: AppColors.primary,
                  backgroundColor:
                      isDark ? AppColors.borderDark : AppColors.borderLight,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                const SizedBox(height: AppConstants.spaceSM),
                Text('Attendance',
                    style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppConstants.spaceMD),
        // Present / Absent counts
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _StatCard(
                label: 'Present',
                value: '${s.presentCount}',
                color: AppColors.success,
                icon: Icons.check_circle_rounded,
                isDark: isDark,
              ),
              const SizedBox(height: AppConstants.spaceSM),
              _StatCard(
                label: 'Absent',
                value: '${s.absentCount}',
                color: AppColors.error,
                icon: Icons.cancel_rounded,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceMD, vertical: AppConstants.spaceSM),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppConstants.radiusSM),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: AppConstants.spaceSM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: AppTextStyles.h2.copyWith(color: color)),
              Text(label,
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

// ── Day Detail ────────────────────────────────────────────────────────────────
class _DayDetail extends StatelessWidget {
  final DateTime day;
  final List<AttendanceRecord> records;
  final bool isDark;

  const _DayDetail(
      {required this.day, required this.records, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${day.day} ${_monthName(day.month)} ${day.year}',
          style: AppTextStyles.h3.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: AppConstants.spaceSM),
        ...records.map((r) => Padding(
              padding:
                  const EdgeInsets.only(bottom: AppConstants.spaceSM),
              child: AppCard(
                padding: const EdgeInsets.all(AppConstants.spaceSM),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: r.isPresent
                            ? AppColors.success
                            : AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spaceSM),
                    Expanded(
                      child: Text(r.course.title,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          )),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (r.isPresent
                                ? AppColors.success
                                : AppColors.error)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusFull),
                      ),
                      child: Text(
                        r.isPresent ? 'Present' : 'Absent',
                        style: AppTextStyles.caption.copyWith(
                          color: r.isPresent
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  String _monthName(int m) => const [
        '',
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];
}

// ── Legend ────────────────────────────────────────────────────────────────────
class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

