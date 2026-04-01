import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/network_image_widget.dart';
import '../../core/widgets/shimmer_widgets.dart';
import '../../data/models/certificate_model.dart';
import 'certificate_detail_screen.dart';
import 'certificates_controller.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(CertificatesController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: Text('My Certificates',
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
                    onPressed: ctrl.fetchCertificates,
                    child: const Text('Retry')),
              ],
            ),
          );
        }
        if (ctrl.certificates.isEmpty) {
          return _EmptyState(isDark: isDark);
        }
        return RefreshIndicator(
          onRefresh: ctrl.fetchCertificates,
          child: ListView.separated(
            padding: const EdgeInsets.all(AppConstants.spaceMD),
            itemCount: ctrl.certificates.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppConstants.spaceMD),
            itemBuilder: (context, i) => _CertificateCard(
              cert: ctrl.certificates[i],
              isDark: isDark,
            )
                .animate(delay: Duration(milliseconds: i * 80))
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
          ),
        );
      }),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final CertificateModel cert;
  final bool isDark;

  const _CertificateCard({required this.cert, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Get.to(() => CertificateDetailScreen(certId: cert.id)),
      child: Row(
        children: [
          // Certificate thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            child: NetworkImageWidget(
              url: cert.fileUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              placeholder: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMD),
                ),
                child: const Icon(Icons.workspace_premium_rounded,
                    color: Colors.white, size: 32),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cert.title,
                    style: AppTextStyles.h3.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(cert.course.title,
                    style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    )),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _StatusBadge(status: cert.status),
                    const SizedBox(width: AppConstants.spaceSM),
                    Text(cert.issueDate,
                        style: AppTextStyles.caption.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        )),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.spaceSM),
          Icon(Icons.chevron_right_rounded,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color =
        status == 'issued' ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.workspace_premium_outlined,
                  size: 80,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight)
              .animate()
              .scale(
                  begin: const Offset(0.5, 0.5),
                  duration: 500.ms,
                  curve: Curves.elasticOut),
          const SizedBox(height: AppConstants.spaceMD),
          Text('No certificates yet',
              style: AppTextStyles.h2.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              )),
          const SizedBox(height: AppConstants.spaceSM),
          Text('Complete a course to earn your certificate',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              )),
        ],
      ),
    );
  }
}

