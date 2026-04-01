import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_routes.dart';
import '../../core/widgets/app_card.dart';
import '../../data/dummy/dummy_data.dart';
import '../attendance/attendance_screen.dart';
import '../assignments/assignments_screen.dart';
import '../exams/exams_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const user = DummyData.userProfile;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Profile header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration:
                    const BoxDecoration(gradient: AppColors.navyGradient),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppConstants.spaceLG),
                      // Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundImage: NetworkImage(user['avatar']),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(Icons.edit_rounded,
                                  color: AppColors.primary, size: 14),
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

                      Text(
                        user['name'],
                        style: AppTextStyles.h2.copyWith(color: Colors.white),
                      ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

                      Text(
                        user['email'],
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ).animate(delay: 150.ms).fadeIn(duration: 400.ms),
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
                // Stats row
                Row(
                  children: [
                    _StatItem(
                      value: '${user['enrolledCourses']}',
                      label: 'Enrolled',
                      isDark: isDark,
                    ),
                    _Divider(),
                    _StatItem(
                      value: '${user['completedCourses']}',
                      label: 'Completed',
                      isDark: isDark,
                    ),
                    _Divider(),
                    _StatItem(
                      value: '${user['certificates']}',
                      label: 'Certificates',
                      isDark: isDark,
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppConstants.spaceLG),

                // Quick access menu
                Text(
                  'Quick Access',
                  style: AppTextStyles.h2.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

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
                  ],
                  isDark: isDark,
                ).animate(delay: 150.ms).fadeIn(duration: 400.ms),

                const SizedBox(height: AppConstants.spaceMD),

                Text(
                  'Account',
                  style: AppTextStyles.h2.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

                const SizedBox(height: AppConstants.spaceMD),

                _MenuSection(
                  items: [
                    _MenuItem(
                      icon: Icons.person_outline_rounded,
                      label: 'Edit Profile',
                      color: AppColors.primary,
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      color: AppColors.secondary,
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: isDark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      label: isDark ? 'Light Mode' : 'Dark Mode',
                      color: AppColors.warning,
                      onTap: () {
                        Get.changeThemeMode(
                          isDark ? ThemeMode.light : ThemeMode.dark,
                        );
                      },
                    ),
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Help & Support',
                      color: AppColors.info,
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.logout_rounded,
                      label: 'Logout',
                      color: AppColors.error,
                      onTap: () => Get.offAllNamed(AppRoutes.login),
                    ),
                  ],
                  isDark: isDark,
                ).animate(delay: 250.ms).fadeIn(duration: 400.ms),

                const SizedBox(height: AppConstants.spaceXL),

                Center(
                  child: Text(
                    'EduPrime v1.0.0',
                    style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ).animate(delay: 300.ms).fadeIn(duration: 400.ms),

                const SizedBox(height: AppConstants.spaceLG),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;

  const _StatItem({
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.h1.copyWith(
              color: AppColors.primary,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 1,
      height: 40,
      color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
    );
  }
}

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
                        child: Text(
                          item.label,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        size: 20,
                      ),
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
