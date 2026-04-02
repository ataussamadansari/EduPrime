import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/network_image_widget.dart';
import '../../data/models/user_model.dart';
import 'edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(EditProfileController());
    final user = Get.arguments as UserModel?;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile',
            style: AppTextStyles.h2.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar picker ──────────────────────────────────────────────
            Center(
              child: Obx(() {
                final picked = ctrl.pickedAvatarPath!.value;
                return GestureDetector(
                  onTap: ctrl.pickAvatar,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.15),
                        child: ClipOval(
                          child: picked.isNotEmpty
                              ? Image.file(File(picked),
                                  width: 96,
                                  height: 96,
                                  fit: BoxFit.cover)
                              : NetworkImageWidget(
                                  url: user?.avatarUrl,
                                  width: 96,
                                  height: 96,
                                  fit: BoxFit.cover,
                                  placeholder: Text(
                                    user?.name.isNotEmpty == true
                                        ? user!.name[0].toUpperCase()
                                        : '?',
                                    style: AppTextStyles.h1
                                        .copyWith(color: AppColors.primary),
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt_rounded,
                              color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ).animate().scale(
                begin: const Offset(0.8, 0.8),
                duration: 400.ms,
                curve: Curves.easeOut),

            const SizedBox(height: AppConstants.spaceLG),

            _field(ctrl.nameCtrl, 'Full Name', Icons.person_outline_rounded,
                isDark, 0),
            _field(ctrl.headlineCtrl, 'Headline', Icons.title_rounded, isDark,
                60),
            _field(ctrl.bioCtrl, 'Bio', Icons.info_outline_rounded, isDark,
                120,
                maxLines: 3),
            _field(ctrl.dobCtrl, 'Date of Birth (YYYY-MM-DD)',
                Icons.cake_rounded, isDark, 150,
                hint: '2001-08-14'),

            // Gender dropdown
            Padding(
              padding:
                  const EdgeInsets.only(bottom: AppConstants.spaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gender',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      )),
                  const SizedBox(height: AppConstants.spaceSM),
                  Obx(() => DropdownButtonFormField<String>(
                        initialValue: ctrl.gender.value.isEmpty
                            ? null
                            : ctrl.gender.value,
                        hint: Text('Select gender',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            )),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.wc_rounded,
                              color: AppColors.primary, size: 20),
                          filled: true,
                          fillColor: isDark
                              ? AppColors.cardDark
                              : AppColors.surfaceLight,
                        ),
                        dropdownColor: isDark
                            ? AppColors.cardDark
                            : AppColors.surfaceLight,
                        items: ['male', 'female', 'other']
                            .map((g) => DropdownMenuItem(
                                value: g,
                                child: Text(
                                    g[0].toUpperCase() + g.substring(1))))
                            .toList(),
                        onChanged: (v) => ctrl.gender.value = v ?? '',
                      )),
                ],
              ),
            ).animate(delay: 180.ms).fadeIn(duration: 350.ms),

            _field(ctrl.addressCtrl, 'Address', Icons.home_outlined, isDark,
                210,
                maxLines: 2),
            _field(ctrl.cityCtrl, 'City', Icons.location_city_rounded, isDark,
                240),
            _field(ctrl.stateCtrl, 'State', Icons.map_outlined, isDark, 270),
            _field(ctrl.countryCtrl, 'Country', Icons.flag_outlined, isDark,
                300),
            _field(ctrl.pincodeCtrl, 'Pincode', Icons.pin_drop_rounded, isDark,
                330,
                keyboardType: TextInputType.number),

            const SizedBox(height: AppConstants.spaceSM),

            Obx(() => ctrl.error.value.isNotEmpty
                ? Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppConstants.spaceMD),
                    child: Text(ctrl.error.value,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.error)),
                  )
                : const SizedBox.shrink()),

            Obx(() => AppButton(
                  label: 'Save Changes',
                  onTap: ctrl.save,
                  isLoading: ctrl.isLoading.value,
                  icon: Icons.check_rounded,
                )).animate(delay: 360.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: AppConstants.spaceLG),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon,
    bool isDark,
    int delay, {
    int maxLines = 1,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.labelLarge.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              )),
          const SizedBox(height: AppConstants.spaceSM),
          TextFormField(
            controller: ctrl,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: AppTextStyles.bodyLarge.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
              hintText: hint ?? label,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.1, end: 0);
  }
}
