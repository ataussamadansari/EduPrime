import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/network_image_widget.dart';
import '../../data/models/exam_api_model.dart';
import '../../data/repositories/exam_repository.dart';

class ExamDetailScreen extends StatefulWidget {
  final int examId;
  const ExamDetailScreen({super.key, required this.examId});

  @override
  State<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends State<ExamDetailScreen> {
  ExamApiModel? _exam;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final e = await ExamRepository().getExamDetail(widget.examId);
      if (mounted) setState(() => _exam = e);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: Text('Exam Detail',
            style: AppTextStyles.h2.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            )),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!,
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.error),
                          textAlign: TextAlign.center),
                      const SizedBox(height: AppConstants.spaceMD),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              _error = null;
                            });
                            _load();
                          },
                          child: const Text('Retry')),
                    ],
                  ),
                )
              : _ExamDetailBody(exam: _exam!, isDark: isDark),
    );
  }
}

class _ExamDetailBody extends StatelessWidget {
  final ExamApiModel exam;
  final bool isDark;
  const _ExamDetailBody({required this.exam, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + status
          Text(exam.title,
                  style: AppTextStyles.h1.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ))
              .animate()
              .fadeIn(duration: 400.ms),
          const SizedBox(height: 6),
          Text(exam.course.title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: AppConstants.spaceMD),

          // Meta chips
          Wrap(
            spacing: AppConstants.spaceSM,
            runSpacing: AppConstants.spaceSM,
            children: [
              _chip(Icons.calendar_today_rounded, exam.examDate,
                  AppColors.info),
              _chip(Icons.access_time_rounded,
                  '${exam.startTime.substring(0, 5)} – ${exam.endTime.substring(0, 5)}',
                  AppColors.secondary),
              _chip(Icons.timer_rounded, '${exam.durationMinutes} min',
                  AppColors.warning),
              _chip(Icons.videocam_rounded, exam.mode, AppColors.success),
            ],
          ).animate(delay: 60.ms).fadeIn(duration: 400.ms),

          const SizedBox(height: AppConstants.spaceLG),

          // Teacher
          AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: ClipOval(
                    child: NetworkImageWidget(
                      url: exam.teacher.avatarUrl,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      placeholder: Text(
                        exam.teacher.name.isNotEmpty
                            ? exam.teacher.name[0].toUpperCase()
                            : '?',
                        style: AppTextStyles.labelLarge
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spaceMD),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exam.teacher.name,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        )),
                    if (exam.teacher.qualification != null)
                      Text(exam.teacher.qualification!,
                          style: AppTextStyles.caption.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          )),
                  ],
                ),
              ],
            ),
          ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

          const SizedBox(height: AppConstants.spaceLG),

          // Instructions
          if (exam.instructions != null) ...[
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
                    child: Text(exam.instructions!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          height: 1.5,
                        )),
                  ),
                ],
              ),
            ).animate(delay: 130.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: AppConstants.spaceLG),
          ],

          // Join link (upcoming online)
          if (exam.isScheduled && exam.meetingLink != null) ...[
            _sectionTitle('Join Exam', isDark),
            const SizedBox(height: AppConstants.spaceSM),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (exam.platformName != null)
                    Row(
                      children: [
                        const Icon(Icons.videocam_rounded,
                            color: AppColors.primary, size: 16),
                        const SizedBox(width: 6),
                        Text(exam.platformName!,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            )),
                      ],
                    ),
                  const SizedBox(height: AppConstants.spaceSM),
                  Row(
                    children: [
                      Expanded(
                        child: Text(exam.meetingLink!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded,
                            size: 16, color: AppColors.primary),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: exam.meetingLink!));
                          Get.snackbar('Copied!', 'Meeting link copied.',
                              snackPosition: SnackPosition.BOTTOM);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ).animate(delay: 160.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: AppConstants.spaceMD),
            AppButton(
              label: 'Join ${exam.platformName ?? "Meeting"}',
              onTap: () async {
                final uri = Uri.parse(exam.meetingLink!);
                try {
                  await launchUrl(uri,
                      mode: LaunchMode.externalApplication);
                } catch (_) {
                  Get.snackbar('Error', 'Could not open the meeting link.',
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
              icon: Icons.open_in_new_rounded,
            ).animate(delay: 180.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: AppConstants.spaceLG),
          ],

          // Result (past exam)
          if (exam.isCompleted && exam.result != null) ...[
            _sectionTitle('Result', isDark),
            const SizedBox(height: AppConstants.spaceSM),
            _ResultCard(result: exam.result!, isDark: isDark)
                .animate(delay: 160.ms)
                .fadeIn(duration: 400.ms),
          ],

          const SizedBox(height: AppConstants.spaceXL),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) => Container(
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

  Widget _sectionTitle(String title, bool isDark) => Text(title,
      style: AppTextStyles.h2.copyWith(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ));
}

// ── Result Card ───────────────────────────────────────────────────────────────
class _ResultCard extends StatelessWidget {
  final ExamResult result;
  final bool isDark;
  const _ResultCard({required this.result, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = result.percentage >= 75
        ? AppColors.success
        : result.percentage >= 50
            ? AppColors.warning
            : AppColors.error;

    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(result.grade,
                          style: AppTextStyles.h1.copyWith(color: color)),
                      Text('${result.percentage.toStringAsFixed(0)}%',
                          style: AppTextStyles.caption
                              .copyWith(color: color)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spaceMD),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${result.marksObtained} / ${result.maxMarks}',
                    style: AppTextStyles.h2.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  Text('marks obtained',
                      style: AppTextStyles.caption.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      )),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusFull),
                    ),
                    child: Text(
                      result.resultStatus[0].toUpperCase() +
                          result.resultStatus.substring(1),
                      style: AppTextStyles.caption
                          .copyWith(color: color, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (result.remarks != null && result.remarks!.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spaceMD),
            Container(
              width: double.infinity,
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
                    child: Text(result.remarks!,
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
