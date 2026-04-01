import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/shimmer_widgets.dart';
import '../../data/models/notification_model.dart';
import 'notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(NotificationsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: Text('Notifications',
            style: AppTextStyles.h2.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            )),
        actions: [
          Obx(() => ctrl.notifications.any((n) => !n.isRead)
              ? TextButton(
                  onPressed: ctrl.markAllRead,
                  child: Text('Mark all read',
                      style: AppTextStyles.labelMedium
                          .copyWith(color: AppColors.primary)),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const ListShimmer(count: 6, itemHeight: 80);
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
                    onPressed: ctrl.fetchAll, child: const Text('Retry')),
              ],
            ),
          );
        }
        if (ctrl.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none_rounded,
                        size: 72,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight)
                    .animate()
                    .scale(
                        begin: const Offset(0.5, 0.5),
                        duration: 500.ms,
                        curve: Curves.elasticOut),
                const SizedBox(height: AppConstants.spaceMD),
                Text('No notifications',
                    style: AppTextStyles.h3.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    )),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: ctrl.fetchAll,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
                vertical: AppConstants.spaceSM),
            itemCount: ctrl.notifications.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              indent: AppConstants.spaceMD,
              endIndent: AppConstants.spaceMD,
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            ),
            itemBuilder: (context, i) {
              final n = ctrl.notifications[i];
              return _NotificationTile(
                notification: n,
                isDark: isDark,
                onTap: () {
                  if (!n.isRead) ctrl.markAsRead(n.id);
                },
              )
                  .animate(delay: Duration(milliseconds: i * 40))
                  .fadeIn(duration: 300.ms);
            },
          ),
        );
      }),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final bool isDark;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = notification;
    final isUnread = !n.isRead;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isUnread
            ? AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.04)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceMD,
          vertical: AppConstants.spaceMD,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _audienceColor(n.audience).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _audienceIcon(n.audience),
                color: _audienceColor(n.audience),
                size: 20,
              ),
            ),
            const SizedBox(width: AppConstants.spaceMD),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(n.title,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontWeight: isUnread
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            )),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(n.message,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        height: 1.4,
                      )),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _AudienceBadge(audience: n.audience),
                      const Spacer(),
                      Text(
                        _timeAgo(n.publishedAt),
                        style: AppTextStyles.caption.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _audienceColor(String a) {
    switch (a) {
      case 'broadcast':
        return AppColors.info;
      case 'course':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  IconData _audienceIcon(String a) {
    switch (a) {
      case 'broadcast':
        return Icons.campaign_rounded;
      case 'course':
        return Icons.school_rounded;
      default:
        return Icons.person_rounded;
    }
  }

  String _timeAgo(String iso) {
    try {
      final d = DateTime.parse(iso).toLocal();
      final diff = DateTime.now().difference(d);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return '';
    }
  }
}

class _AudienceBadge extends StatelessWidget {
  final String audience;
  const _AudienceBadge({required this.audience});

  @override
  Widget build(BuildContext context) {
    final color = audience == 'broadcast'
        ? AppColors.info
        : audience == 'course'
            ? AppColors.warning
            : AppColors.success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(audience,
          style: AppTextStyles.caption
              .copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}
