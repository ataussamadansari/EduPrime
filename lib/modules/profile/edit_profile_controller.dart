import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> pickAvatar() async {
    final source = await Get.bottomSheet<ImageSource>(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Camera'),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Gallery'),
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
        imageQuality: 80,
        maxWidth: 800,
      );
      if (file != null) pickedAvatarPath!.value = file.path;
    } catch (e) {
      Get.snackbar('Error', 'Could not pick image. Please restart the app.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

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

      final avatarPath = pickedAvatarPath!.value.isNotEmpty
          ? pickedAvatarPath!.value
          : null;

      final updated =
          await _repo.updateProfile(fields, avatarPath: avatarPath);
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
