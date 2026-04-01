import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/network_image_widget.dart';
import '../../data/models/certificate_model.dart';
import '../../data/repositories/certificate_repository.dart';

class CertificateDetailScreen extends StatefulWidget {
  final int certId;
  const CertificateDetailScreen({super.key, required this.certId});

  @override
  State<CertificateDetailScreen> createState() =>
      _CertificateDetailScreenState();
}

class _CertificateDetailScreenState extends State<CertificateDetailScreen> {
  CertificateModel? _cert;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final c =
          await CertificateRepository().getCertificateDetail(widget.certId);
      if (mounted) setState(() => _cert = c);
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
        title: Text('Certificate',
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
              : _CertificateDetailBody(cert: _cert!, isDark: isDark),
    );
  }
}

class _CertificateDetailBody extends StatelessWidget {
  final CertificateModel cert;
  final bool isDark;

  const _CertificateDetailBody(
      {required this.cert, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Certificate preview
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              gradient: AppColors.navyGradient,
              borderRadius: BorderRadius.circular(AppConstants.radiusXL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusXL),
              child: cert.fileUrl != null
                  ? NetworkImageWidget(
                      url: cert.fileUrl,
                      fit: BoxFit.contain,
                      placeholder: _CertPlaceholder(title: cert.title),
                    )
                  : _CertPlaceholder(title: cert.title),
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: AppConstants.spaceLG),

          // Title
          Text(cert.title,
                  style: AppTextStyles.h1.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  textAlign: TextAlign.center)
              .animate(delay: 100.ms)
              .fadeIn(duration: 400.ms),

          const SizedBox(height: AppConstants.spaceSM),

          // Course name
          Text(cert.course.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center)
              .animate(delay: 130.ms)
              .fadeIn(duration: 400.ms),

          const SizedBox(height: AppConstants.spaceLG),

          // Details card
          _DetailCard(cert: cert, isDark: isDark)
              .animate(delay: 180.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: AppConstants.spaceLG),

          // Copy verification URL
          if (cert.verificationUrl != null)
            AppButton(
              label: 'Copy Verification Link',
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: cert.verificationUrl!));
                Get.snackbar('Copied!', 'Verification link copied.',
                    snackPosition: SnackPosition.BOTTOM);
              },
              icon: Icons.copy_rounded,
            ).animate(delay: 250.ms).fadeIn(duration: 400.ms),

          const SizedBox(height: AppConstants.spaceLG),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final CertificateModel cert;
  final bool isDark;
  const _DetailCard({required this.cert, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spaceMD),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _Row(
            label: 'Certificate Code',
            value: cert.certificateCode,
            isDark: isDark,
            valueStyle: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primary,
              letterSpacing: 1,
            ),
          ),
          _Divider(isDark: isDark),
          _Row(
              label: 'Issue Date',
              value: cert.issueDate,
              isDark: isDark),
          _Divider(isDark: isDark),
          _Row(label: 'Status', value: '', isDark: isDark,
              trailing: _StatusBadge(status: cert.status)),
          if (cert.description != null) ...[
            _Divider(isDark: isDark),
            _Row(
                label: 'Description',
                value: cert.description!,
                isDark: isDark),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final TextStyle? valueStyle;
  final Widget? trailing;

  const _Row({
    required this.label,
    required this.value,
    required this.isDark,
    this.valueStyle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceSM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                )),
          ),
          Expanded(
            child: trailing ??
                Text(value,
                    style: valueStyle ??
                        AppTextStyles.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                        )),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) => Divider(
        height: 1,
        color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
      );
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
        style: AppTextStyles.caption
            .copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _CertPlaceholder extends StatelessWidget {
  final String title;
  const _CertPlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.workspace_premium_rounded,
              color: AppColors.primary, size: 56),
          const SizedBox(height: AppConstants.spaceSM),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spaceMD),
            child: Text(title,
                style: AppTextStyles.h3
                    .copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
