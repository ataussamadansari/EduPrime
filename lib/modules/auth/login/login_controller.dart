import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_routes.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString errorText = ''.obs;

  final _repo = AuthRepository();

  bool _validate() {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      errorText.value = 'Please enter your mobile number';
      return false;
    }
    if (phone.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
      errorText.value = 'Enter a valid 10-digit mobile number';
      return false;
    }
    errorText.value = '';
    return true;
  }

  Future<void> sendOtp() async {
    if (!_validate()) return;
    isLoading.value = true;
    try {
      final result = await _repo.sendOtp(phoneController.text.trim());
      if (result.otpSent) {
        Get.toNamed(
          AppRoutes.otp,
          arguments: {
            'mobile': phoneController.text.trim(),
            'otp': result.otp, // available in dev/staging
          },
        );
      } else {
        errorText.value = result.message ?? 'Failed to send OTP';
      }
    } catch (e) {
      errorText.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
