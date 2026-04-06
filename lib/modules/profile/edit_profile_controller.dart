import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/profile_repository.dart';

class EditProfileController extends GetxController {
  final _repo = ProfileRepository();
  final _picker = ImagePicker();

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString? pickedAvatarPath = RxString('');

  late final TextEditingController nameCtrl;
  late final TextEditingController headlineCtrl;
  late final TextEditingController bioCtrl;
  late final TextEditingController cityCtrl;
  late final TextEditingController stateCtrl;
  late final TextEditingController countryCtrl;
  late final TextEditingController addressCtrl;
  late final TextEditingController pincodeCtrl;
  late final TextEditingController dobCtrl;
  final RxString gender = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final user = Get.arguments as UserModel?;
    nameCtrl = TextEditingController(text: user?.name ?? '');
    headlineCtrl = TextEditingController(text: user?.headline ?? '');
    bioCtrl = TextEditingController(text: user?.bio ?? '');
    cityCtrl = TextEditingController(text: user?.city ?? '');
    stateCtrl = TextEditingController(text: user?.state ?? '');
    countryCtrl = TextEditingController(text: user?.country ?? '');
    addressCtrl = TextEditingController(text: user?.address ?? '');
    pincodeCtrl = TextEditingController(text: user?.pincode ?? '');
    dobCtrl = TextEditingController(text: user?.dateOfBirth ?? '');
    gender.value = user?.gender ?? '';
  }

  // ── Date of Birth calendar picker ─────────────────────────────────────────
  Future<void> pickDateOfBirth(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Parse existing date if any
    DateTime initial = DateTime.now().subtract(const Duration(days: 365 * 18));
    if (dobCtrl.text.isNotEmpty) {
      try {
        initial = DateFormat('yyyy-MM-dd').parse(dobCtrl.text);
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      helpText: 'Select Date of Birth',
      builder: (context, child) {
        return Theme(
          data: isDark ? _darkCalendarTheme() : _lightCalendarTheme(),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Store as yyyy-MM-dd for API, display as dd MMM yyyy
      dobCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  ThemeData _lightCalendarTheme() => ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: AppColors.textPrimaryLight,
        ),
        dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
      );

  ThemeData _darkCalendarTheme() => ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          surface: AppColors.cardDark,
          onSurface: AppColors.textPrimaryDark,
        ),
        dialogTheme: const DialogThemeData(backgroundColor: AppColors.cardDark),
      );

  // ── Avatar picker with crop ────────────────────────────────────────────────
  Future<void> pickAvatar(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.cardDark : Colors.white;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    final source = await Get.bottomSheet<ImageSource>(
      Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(height: 16),
            Text('Choose Photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                )),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
              title: Text('Camera', style: TextStyle(color: textColor)),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library_rounded, color: AppColors.primary),
              title: Text('Gallery', style: TextStyle(color: textColor)),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: 90,
        maxWidth: 1200,
      );
      if (file == null) return;

      // Crop — square lock
      final cropped = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Photo',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            statusBarLight: false,
            // statusBarColor: AppColors.primaryDark,
            activeControlsWidgetColor: AppColors.primary,
            backgroundColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            showCropGrid: true,
          ),
          IOSUiSettings(
            title: 'Crop Photo',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (cropped != null) {
        pickedAvatarPath!.value = cropped.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not pick image.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ── Save ───────────────────────────────────────────────────────────────────
  Future<void> save() async {
    if (nameCtrl.text.trim().isEmpty) {
      error.value = 'Name cannot be empty';
      return;
    }
    isLoading.value = true;
    error.value = '';
    try {
      final fields = <String, dynamic>{
        'name': nameCtrl.text.trim(),
        if (headlineCtrl.text.trim().isNotEmpty)
          'headline': headlineCtrl.text.trim(),
        if (bioCtrl.text.trim().isNotEmpty) 'bio': bioCtrl.text.trim(),
        if (cityCtrl.text.trim().isNotEmpty) 'city': cityCtrl.text.trim(),
        if (stateCtrl.text.trim().isNotEmpty) 'state': stateCtrl.text.trim(),
        if (countryCtrl.text.trim().isNotEmpty)
          'country': countryCtrl.text.trim(),
        if (addressCtrl.text.trim().isNotEmpty)
          'address': addressCtrl.text.trim(),
        if (pincodeCtrl.text.trim().isNotEmpty)
          'pincode': pincodeCtrl.text.trim(),
        if (dobCtrl.text.trim().isNotEmpty)
          'date_of_birth': dobCtrl.text.trim(),
        if (gender.value.isNotEmpty) 'gender': gender.value,
      };

      final avatarPath =
          pickedAvatarPath!.value.isNotEmpty ? pickedAvatarPath!.value : null;

      final updated = await _repo.updateProfile(fields, avatarPath: avatarPath);
      Get.back(result: updated);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    headlineCtrl.dispose();
    bioCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    countryCtrl.dispose();
    addressCtrl.dispose();
    pincodeCtrl.dispose();
    dobCtrl.dispose();
    super.onClose();
  }
}
