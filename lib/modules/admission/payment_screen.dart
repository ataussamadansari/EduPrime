import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/models/course_model.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;
  bool _isProcessing = false;

  static const List<_PaymentMethod> _methods = [
    _PaymentMethod(
      label: 'UPI',
      subtitle: 'Pay via any UPI app',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF6C63FF),
    ),
    _PaymentMethod(
      label: 'Credit / Debit Card',
      subtitle: 'Visa, Mastercard, RuPay',
      icon: Icons.credit_card_rounded,
      color: Color(0xFFFF6584),
    ),
    _PaymentMethod(
      label: 'Net Banking',
      subtitle: 'All major banks supported',
      icon: Icons.account_balance_rounded,
      color: Color(0xFF43E97B),
    ),
    _PaymentMethod(
      label: 'EMI',
      subtitle: 'No-cost EMI available',
      icon: Icons.calendar_month_rounded,
      color: Color(0xFFF59E0B),
    ),
  ];

  Future<void> _pay(CourseModel? course) async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() => _isProcessing = false);
    Get.offNamed(AppRoutes.paymentSuccess, arguments: course);
  }

  @override
  Widget build(BuildContext context) {
    final course = Get.arguments as CourseModel?;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: Text(
          'Payment',
          style: AppTextStyles.h2.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order summary
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary',
                    style: AppTextStyles.h3.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceMD),
                  _OrderRow(
                    label: course?.title ?? 'Course',
                    value: '₹${course?.price.toStringAsFixed(0) ?? '0'}',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  _OrderRow(
                      label: 'GST (18%)',
                      value:
                          '₹${((course?.price ?? 0) * 0.18).toStringAsFixed(0)}',
                      isDark: isDark),
                  Divider(
                    color:
                        isDark ? AppColors.dividerDark : AppColors.dividerLight,
                    height: AppConstants.spaceLG,
                  ),
                  _OrderRow(
                    label: 'Total',
                    value:
                        '₹${((course?.price ?? 0) * 1.18).toStringAsFixed(0)}',
                    isDark: isDark,
                    isBold: true,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: AppConstants.spaceLG),

            Text(
              'Select Payment Method',
              style: AppTextStyles.h2.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: AppConstants.spaceMD),

            // Payment methods
            ...List.generate(_methods.length, (i) {
              final method = _methods[i];
              final isSelected = _selectedMethod == i;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spaceSM),
                child: InkWell(
                  onTap: () => setState(() => _selectedMethod = i),
                  borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                  child: AnimatedContainer(
                    duration: AppConstants.animFast,
                    padding: const EdgeInsets.all(AppConstants.spaceMD),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : (isDark ? AppColors.cardDark : AppColors.cardLight),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusLG),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: method.color.withValues(alpha: 0.12),
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusMD),
                          ),
                          child:
                              Icon(method.icon, color: method.color, size: 22),
                        ),
                        const SizedBox(width: AppConstants.spaceMD),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method.label,
                                style: AppTextStyles.h3.copyWith(
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                              ),
                              Text(
                                method.subtitle,
                                style: AppTextStyles.caption.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: AppConstants.animFast,
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark
                                      ? AppColors.borderDark
                                      : AppColors.borderLight),
                              width: 2,
                            ),
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 14)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  .animate(delay: Duration(milliseconds: 150 + i * 60))
                  .fadeIn(duration: 350.ms)
                  .slideX(begin: 0.1, end: 0);
            }),

            const SizedBox(height: AppConstants.spaceXL),

            AppButton(
              label: 'Pay ₹${((course?.price ?? 0) * 1.18).toStringAsFixed(0)}',
              onTap: () => _pay(course),
              isLoading: _isProcessing,
              icon: Icons.lock_rounded,
            )
                .animate(delay: 400.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.2, end: 0),

            const SizedBox(height: AppConstants.spaceMD),

            // Security note
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security_rounded,
                    color: AppColors.success, size: 14),
                const SizedBox(width: 6),
                Text(
                  '100% Secure Payment',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ).animate(delay: 450.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: AppConstants.spaceMD),
          ],
        ),
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool isBold;

  const _OrderRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              (isBold ? AppTextStyles.h3 : AppTextStyles.bodyMedium).copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        Text(
          value,
          style:
              (isBold ? AppTextStyles.h3 : AppTextStyles.bodyMedium).copyWith(
            color: isBold
                ? AppColors.primary
                : (isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight),
          ),
        ),
      ],
    );
  }
}

class _PaymentMethod {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _PaymentMethod({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
