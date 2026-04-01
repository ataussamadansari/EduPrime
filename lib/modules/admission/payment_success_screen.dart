import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../data/models/course_model.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final course = Get.arguments as CourseModel?;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spaceLG),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Success animation
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: AppColors.greenGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.35),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(1.0, 1.0),
                    duration: 700.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceXL),

              Text(
                'Payment Successful! 🎉',
                style: AppTextStyles.displayMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
                textAlign: TextAlign.center,
              )
                  .animate(delay: 300.ms)
                  .slideY(begin: 0.3, end: 0, duration: 400.ms)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceMD),

              Text(
                'You are now enrolled in',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ).animate(delay: 400.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceSM),

              if (course != null)
                Text(
                  course.title,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ).animate(delay: 450.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceXL),

              // Confetti-like decorative elements
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ConfettiDot(color: AppColors.primary, delay: 500),
                  _ConfettiDot(color: AppColors.secondary, delay: 600),
                  _ConfettiDot(color: AppColors.success, delay: 700),
                  _ConfettiDot(color: AppColors.warning, delay: 800),
                  _ConfettiDot(color: AppColors.info, delay: 900),
                ],
              ),

              const Spacer(),

              // Transaction ID
              Container(
                padding: const EdgeInsets.all(AppConstants.spaceMD),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                  border: Border.all(
                    color:
                        isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction ID',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    Text(
                      'TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 600.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceLG),

              AppButton(
                label: 'Start Learning Now',
                onTap: () => Get.offAllNamed(AppRoutes.home),
                icon: Icons.play_arrow_rounded,
              )
                  .animate(delay: 700.ms)
                  .slideY(begin: 0.3, end: 0, duration: 400.ms)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceMD),

              TextButton(
                onPressed: () => Get.offAllNamed(AppRoutes.home),
                child: Text(
                  'Go to Dashboard',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ).animate(delay: 800.ms).fadeIn(duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfettiDot extends StatelessWidget {
  final Color color;
  final int delay;

  const _ConfettiDot({required this.color, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    )
        .animate(delay: Duration(milliseconds: delay))
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          duration: 400.ms,
          curve: Curves.elasticOut,
        )
        .then()
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: -8, duration: 800.ms);
  }
}
