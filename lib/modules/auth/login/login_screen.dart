import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_button.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spaceLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.spaceXL),

              // Logo
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset('assets/images/app_logo.png',
                    fit: BoxFit.contain),
              )
                  .animate()
                  .scale(
                      begin: const Offset(0.5, 0.5),
                      duration: 500.ms,
                      curve: Curves.elasticOut)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceLG),

              Text(
                'Welcome Back 👋',
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

              Text(
                'Enter your mobile number to continue learning',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              )
                  .animate(delay: 150.ms)
                  .slideX(begin: -0.2, end: 0, duration: 400.ms)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceXXL),

              // Phone input
              Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mobile Number',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spaceSM),
                          TextFormField(
                            controller: controller.phoneController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (_) => controller.errorText.value = '',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: '98765 43210',
                              hintStyle: AppTextStyles.bodyLarge.copyWith(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                                letterSpacing: 2,
                              ),
                              prefixIcon: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.spaceMD,
                                  vertical: AppConstants.spaceSM,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('🇮🇳',
                                        style: TextStyle(fontSize: 20)),
                                    const SizedBox(width: 6),
                                    Text(
                                      '+91',
                                      style: AppTextStyles.labelLarge.copyWith(
                                        color: isDark
                                            ? AppColors.textPrimaryDark
                                            : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 1,
                                      height: 20,
                                      color: isDark
                                          ? AppColors.borderDark
                                          : AppColors.borderLight,
                                    ),
                                  ],
                                ),
                              ),
                              errorText: controller.errorText.value.isEmpty
                                  ? null
                                  : controller.errorText.value,
                            ),
                          ),
                        ],
                      ))
                  .animate(delay: 250.ms)
                  .slideY(begin: 0.2, end: 0, duration: 400.ms)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceXL),

              // Send OTP button
              Obx(() => AppButton(
                        label: 'Send OTP',
                        onTap: controller.sendOtp,
                        isLoading: controller.isLoading.value,
                        icon: Icons.send_rounded,
                      ))
                  .animate(delay: 350.ms)
                  .slideY(begin: 0.2, end: 0, duration: 400.ms)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceXL),

              // Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark
                          ? AppColors.dividerDark
                          : AppColors.dividerLight,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spaceMD),
                    child: Text(
                      'or continue with',
                      style: AppTextStyles.caption.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDark
                          ? AppColors.dividerDark
                          : AppColors.dividerLight,
                    ),
                  ),
                ],
              ).animate(delay: 400.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceLG),

              // Social login buttons (UI only)
              Row(
                children: [
                  Expanded(
                    child: _SocialButton(
                      label: 'Google',
                      icon: Icons.g_mobiledata_rounded,
                      color: const Color(0xFFEA4335),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: AppConstants.spaceMD),
                  Expanded(
                    child: _SocialButton(
                      label: 'Apple',
                      icon: Icons.apple_rounded,
                      color: isDark ? Colors.white : Colors.black,
                      onTap: () {},
                    ),
                  ),
                ],
              )
                  .animate(delay: 450.ms)
                  .slideY(begin: 0.2, end: 0, duration: 400.ms)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceXL),

              // Terms
              Center(
                child: Text(
                  'By continuing, you agree to our Terms & Privacy Policy',
                  style: AppTextStyles.caption.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ).animate(delay: 500.ms).fadeIn(duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusMD),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
