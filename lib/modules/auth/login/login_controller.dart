import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_routes.dart';

class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString errorText = ''.obs;

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
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));
    isLoading.value = false;
    Get.toNamed(AppRoutes.otp, arguments: phoneController.text.trim());
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
