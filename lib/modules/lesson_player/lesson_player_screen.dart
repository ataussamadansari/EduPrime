import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_button.dart';
import 'lesson_player_controller.dart';

class LessonPlayerScreen extends StatelessWidget {
  const LessonPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(LessonPlayerController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }
        if (ctrl.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.white54, size: 48),
                const SizedBox(height: AppConstants.spaceMD),
                Text(ctrl.error.value,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: Colors.white70),
                    textAlign: TextAlign.center),
                const SizedBox(height: AppConstants.spaceMD),
                TextButton(
                  onPressed: Get.back,
                  child: const Text('Go Back',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }

        final lesson = ctrl.lesson.value;
        if (lesson == null) return const SizedBox.shrink();

        return Column(
          children: [
            // ── Video Player ──────────────────────────────────────────────
            SafeArea(
              bottom: false,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ctrl.isVideoReady.value && ctrl.chewieCtrl != null
                    ? Chewie(controller: ctrl.chewieCtrl!)
                    : Container(
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                                color: Colors.white54),
                            const SizedBox(height: AppConstants.spaceMD),
                            Text('Loading video...',
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: Colors.white54)),
                          ],
                        ),
                      ),
              ),
            ),

            // ── Lesson Info Panel ─────────────────────────────────────────
            Expanded(
              child: Container(
                color: isDark ? AppColors.bgDark : AppColors.bgLight,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.spaceMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button + title
                      Row(
                        children: [
                          GestureDetector(
                            onTap: Get.back,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.cardDark
                                    : AppColors.cardLight,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusSM),
                              ),
                              child: Icon(Icons.arrow_back_ios_new_rounded,
                                  size: 16,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight),
                            ),
                          ),
                          const SizedBox(width: AppConstants.spaceMD),
                          Expanded(
                            child: Text(lesson.title,
                                style: AppTextStyles.h3.copyWith(
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms),

                      const SizedBox(height: AppConstants.spaceMD),

                      // Meta chips
                      Wrap(
                        spacing: AppConstants.spaceSM,
                        runSpacing: AppConstants.spaceSM,
                        children: [
                          _Chip(
                            icon: Icons.videocam_rounded,
                            label: lesson.lessonType.toUpperCase(),
                            color: AppColors.primary,
                          ),
                          if (lesson.durationMinutes > 0)
                            _Chip(
                              icon: Icons.timer_rounded,
                              label: '${lesson.durationMinutes} min',
                              color: AppColors.secondary,
                            ),
                          Obx(() => ctrl.isCompleted.value
                              ? const _Chip(
                                  icon: Icons.check_circle_rounded,
                                  label: 'Completed',
                                  color: AppColors.success,
                                )
                              : const SizedBox.shrink()),
                        ],
                      ).animate(delay: 80.ms).fadeIn(duration: 400.ms),

                      // Description
                      if (lesson.description != null &&
                          lesson.description!.isNotEmpty) ...[
                        const SizedBox(height: AppConstants.spaceMD),
                        Text('About this Lesson',
                            style: AppTextStyles.h3.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            )),
                        const SizedBox(height: AppConstants.spaceSM),
                        Text(lesson.description!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                              height: 1.6,
                            )),
                      ],

                      const SizedBox(height: AppConstants.spaceLG),

                      // Mark complete / completed badge
                      Obx(() => ctrl.isCompleted.value
                          ? Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.all(AppConstants.spaceMD),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusMD),
                                border: Border.all(
                                    color: AppColors.success.withValues(
                                        alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle_rounded,
                                      color: AppColors.success, size: 20),
                                  const SizedBox(width: 8),
                                  Text('Lesson Completed',
                                      style: AppTextStyles.labelLarge.copyWith(
                                          color: AppColors.success)),
                                ],
                              ),
                            ).animate().fadeIn(duration: 400.ms)
                          : AppButton(
                              label: 'Mark as Complete',
                              onTap: ctrl.markComplete,
                              icon: Icons.check_rounded,
                            ).animate(delay: 150.ms).fadeIn(duration: 400.ms)),

                      const SizedBox(height: AppConstants.spaceMD),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Chip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
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
