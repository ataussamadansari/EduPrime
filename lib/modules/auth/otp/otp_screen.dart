import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_button.dart';
import 'otp_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpController());
    final phone = Get.arguments as String? ?? '**********';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spaceLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.spaceMD),

              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                ),
                child: const Icon(Icons.lock_outline_rounded,
                    color: AppColors.primary, size: 32),
              )
                  .animate()
                  .scale(
                      begin: const Offset(0.5, 0.5),
                      duration: 500.ms,
                      curve: Curves.elasticOut)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceLG),

              Text(
                'Verify OTP',
                style: AppTextStyles.displayMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              )
                  .animate(delay: 100.ms)
                  .slideX(begin: -0.2, end: 0, duration: 400.ms)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceSM),

              RichText(
                text: TextSpan(
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                  children: [
                    const TextSpan(text: 'We sent a 6-digit OTP to '),
                    TextSpan(
                      text: '+91 $phone',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 150.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceXXL),

              // OTP input
              Obx(() => PinCodeTextField(
                        appContext: context,
                        length: AppConstants.otpLength,
                        animationType: AnimationType.scale,
                        keyboardType: TextInputType.number,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMD),
                          fieldHeight: 56,
                          fieldWidth: 48,
                          activeFillColor: isDark
                              ? AppColors.cardDark
                              : AppColors.surfaceLight,
                          inactiveFillColor: isDark
                              ? AppColors.cardDark
                              : AppColors.surfaceLight,
                          selectedFillColor: isDark
                              ? AppColors.cardDark
                              : AppColors.surfaceLight,
                          activeColor: controller.isError.value
                              ? AppColors.error
                              : AppColors.primary,
                          inactiveColor: isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                          selectedColor: AppColors.primary,
                        ),
                        enableActiveFill: true,
                        onChanged: (val) {
                          controller.otp.value = val;
                          controller.isError.value = false;
                        },
                        onCompleted: (_) => controller.verifyOtp(),
                        textStyle: AppTextStyles.h2.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ))
                  .animate(delay: 250.ms)
                  .slideY(begin: 0.2, end: 0, duration: 400.ms)
                  .fadeIn(duration: 400.ms),

              // Error message
              Obx(() => controller.isError.value
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Invalid OTP. Please try again.',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.error),
                      ),
                    )
                  : const SizedBox.shrink()),

              const SizedBox(height: AppConstants.spaceLG),

              // Timer + Resend
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive OTP? ",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                      controller.canResend.value
                          ? GestureDetector(
                              onTap: controller.resendOtp,
                              child: Text(
                                'Resend',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            )
                          : Text(
                              controller.timerDisplay,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                    ],
                  )).animate(delay: 300.ms).fadeIn(duration: 400.ms),

              const Spacer(),

              // Verify button
              Obx(() => AppButton(
                        label: 'Verify & Continue',
                        onTap: controller.otp.value.length ==
                                AppConstants.otpLength
                            ? controller.verifyOtp
                            : null,
                        isLoading: controller.isLoading.value,
                        icon: Icons.verified_rounded,
                      ))
                  .animate(delay: 400.ms)
                  .slideY(begin: 0.3, end: 0, duration: 400.ms)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceMD),
            ],
          ),
        ),
      ),
    );
  }
}
