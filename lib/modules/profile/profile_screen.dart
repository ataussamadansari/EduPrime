import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/network_image_widget.dart';
import '../../core/widgets/shimmer_widgets.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/models/user_model.dart';
import '../attendance/attendance_screen.dart';
import '../assignments/assignments_screen.dart';
import '../certificates/certificates_screen.dart';
import '../exams/exams_screen.dart';
import '../support/support_screen.dart';
import 'edit_profile_screen.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ProfileController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const ProfileShimmer();
        }
        if (ctrl.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(ctrl.error.value,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.error)),
                const SizedBox(height: AppConstants.spaceMD),
                TextButton(
                    onPressed: ctrl.fetchProfile, child: const Text('Retry')),
              ],
            ),
          );
        }
        final user = ctrl.user.value;
        if (user == null) return const SizedBox.shrink();
        return _ProfileBody(ctrl: ctrl, user: user, isDark: isDark);
      }),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final ProfileController ctrl;
  final UserModel user;
  final bool isDark;

  const _ProfileBody({
    required this.ctrl,
    required this.user,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 230,
          pinned: true,
          backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(gradient: AppColors.navyGradient),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppConstants.spaceLG),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.15),
                          child: ClipOval(
                            child: NetworkImageWidget(
                              url: user.avatarUrl,
                              width: 88,
                              height: 88,
                              fit: BoxFit.cover,
                              placeholder: Text(
                                user.name.isNotEmpty
                                    ? user.name[0].toUpperCase()
                                    : '?',
                                style: AppTextStyles.h1
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _goToEdit(ctrl, user),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.primary, width: 2),
                              ),
                              child: const Icon(Icons.edit_rounded,
                                  color: AppColors.primary, size: 14),
                            ),
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0.6, 0.6),
                          duration: 500.ms,
                          curve: Curves.elasticOut,
                        )
                        .fadeIn(duration: 400.ms),
                    const SizedBox(height: AppConstants.spaceSM),
                    Text(user.name,
                            style:
                                AppTextStyles.h2.copyWith(color: Colors.white))
                        .animate(delay: 100.ms)
                        .fadeIn(duration: 400.ms),
                    if (user.headline != null)
                      Text(user.headline!,
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: Colors.white60))
                          .animate(delay: 130.ms)
                          .fadeIn(duration: 400.ms),
                    Text(user.email,
                            style: AppTextStyles.bodySmall
                                .copyWith(color: Colors.white70))
                        .animate(delay: 150.ms)
                        .fadeIn(duration: 400.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppConstants.spaceMD),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Info chips row
              _InfoRow(user: user, isDark: isDark)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppConstants.spaceMD),

              // Quick Stats
              Obx(() {
                final stats = ctrl.quickStats.value;
                if (stats == null) return const SizedBox.shrink();
                return _QuickStatsRow(stats: stats, isDark: isDark)
                    .animate(delay: 80.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0);
              }),

              const SizedBox(height: AppConstants.spaceLG),

              // Quick Access
              Text('Quick Access',
                  style: AppTextStyles.h2.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  )).animate(delay: 100.ms).fadeIn(duration: 400.ms),
              const SizedBox(height: AppConstants.spaceMD),
              _MenuSection(
                items: [
                  _MenuItem(
                    icon: Icons.calendar_today_rounded,
                    label: 'Attendance',
                    color: AppColors.success,
                    onTap: () => Get.to(() => const AttendanceScreen()),
                  ),
                  _MenuItem(
                    icon: Icons.assignment_rounded,
                    label: 'Assignments',
                    color: AppColors.warning,
                    onTap: () => Get.to(() => const AssignmentsScreen()),
                  ),
                  _MenuItem(
                    icon: Icons.quiz_rounded,
                    label: 'Exams',
                    color: AppColors.info,
                    onTap: () => Get.to(() => const ExamsScreen()),
                  ),
                  _MenuItem(
                    icon: Icons.workspace_premium_rounded,
                    label: 'Certificates',
                    color: AppColors.info,
                    onTap: () => Get.to(() => const CertificatesScreen()),
                  ),
                ],
                isDark: isDark,
              ).animate(delay: 150.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceMD),

              // Account
              Text('Account',
                  style: AppTextStyles.h2.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  )).animate(delay: 200.ms).fadeIn(duration: 400.ms),
              const SizedBox(height: AppConstants.spaceMD),
              _MenuSection(
                items: [
                  _MenuItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Edit Profile',
                    color: AppColors.primary,
                    onTap: () => _goToEdit(ctrl, user),
                  ),
                  _MenuItem(
                    icon: isDark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    label: isDark ? 'Light Mode' : 'Dark Mode',
                    color: AppColors.warning,
                    onTap: () => Get.changeThemeMode(
                        isDark ? ThemeMode.light : ThemeMode.dark),
                  ),
                  _MenuItem(
                      icon: Icons.notifications,
                      label: 'Notifications',
                      color: AppColors.primary,
                      onTap: () => {}),
                  _MenuItem(
                    icon: Icons.support_agent_rounded,
                    label: 'Help & Support',
                    color: AppColors.primary,
                    onTap: () => Get.to(() => const SupportScreen()),
                  ),
                  _MenuItem(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    color: AppColors.error,
                    onTap: ctrl.logout,
                  ),
                ],
                isDark: isDark,
              ).animate(delay: 250.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: AppConstants.spaceXL),
              Center(
                child: Text('SSVV OSTC v1.0.0',
                    style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    )),
              ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
              const SizedBox(height: AppConstants.spaceLG),
            ]),
          ),
        ),
      ],
    );
  }

  void _goToEdit(ProfileController ctrl, UserModel user) async {
    final updated = await Get.to(
      () => const EditProfileScreen(),
      arguments: user,
    );
    if (updated is UserModel) {
      ctrl.user.value = updated;
    }
  }
}

// ── Quick Stats Row ───────────────────────────────────────────────────────────
class _QuickStatsRow extends StatelessWidget {
  final QuickStats stats;
  final bool isDark;
  const _QuickStatsRow({required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        Icons.book_rounded,
        '${stats.enrolledCourses}',
        'Enrolled',
        AppColors.primaryGradient,
      ),
      (
        Icons.calendar_today_rounded,
        '${stats.attendancePercentage.toStringAsFixed(1)}%',
        'Attendance',
        AppColors.greenGradient,
      ),
      (
        Icons.assignment_late_rounded,
        '${stats.pendingAssignments}',
        'Pending Assignment',
        AppColors.orangeGradient,
      ),
    ];

    return Row(
      children: items.asMap().entries.map((e) {
        final item = e.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                right: e.key < items.length - 1 ? AppConstants.spaceSM : 0),
            child: Container(
              padding: const EdgeInsets.all(AppConstants.spaceMD),
              decoration: BoxDecoration(
                gradient: item.$4,
                borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.$1, color: Colors.white70, size: 18),
                  const SizedBox(height: 6),
                  Text(item.$2,
                      style: AppTextStyles.h2.copyWith(color: Colors.white)),
                  Text(item.$3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption
                          .copyWith(color: Colors.white70)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Info Row ─────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final UserModel user;
  final bool isDark;
  const _InfoRow({required this.user, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = [
      if (user.city != null) (Icons.location_on_rounded, user.city!),
      if (user.role.isNotEmpty) (Icons.school_rounded, user.role),
      if (user.mobile.isNotEmpty) (Icons.phone_rounded, user.mobile),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppConstants.spaceSM,
      runSpacing: AppConstants.spaceSM,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.$1, size: 13, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(item.$2,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Menu Section ─────────────────────────────────────────────────────────────
class _MenuSection extends StatelessWidget {
  final List<_MenuItem> items;
  final bool isDark;
  const _MenuSection({required this.items, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.only(
                  topLeft: i == 0
                      ? const Radius.circular(AppConstants.radiusLG)
                      : Radius.zero,
                  topRight: i == 0
                      ? const Radius.circular(AppConstants.radiusLG)
                      : Radius.zero,
                  bottomLeft: i == items.length - 1
                      ? const Radius.circular(AppConstants.radiusLG)
                      : Radius.zero,
                  bottomRight: i == items.length - 1
                      ? const Radius.circular(AppConstants.radiusLG)
                      : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spaceMD,
                    vertical: AppConstants.spaceMD,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusSM),
                        ),
                        child: Icon(item.icon, color: item.color, size: 18),
                      ),
                      const SizedBox(width: AppConstants.spaceMD),
                      Expanded(
                        child: Text(item.label,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            )),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          size: 20),
                    ],
                  ),
                ),
              ),
              if (i < items.length - 1)
                Divider(
                  height: 1,
                  indent: AppConstants.spaceMD + 38 + AppConstants.spaceMD,
                  color:
                      isDark ? AppColors.dividerDark : AppColors.dividerLight,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
