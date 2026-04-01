import 'dart:async';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_routes.dart';

class OtpController extends GetxController {
  final RxString otp = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxInt timerSeconds = AppConstants.otpTimerSeconds.obs;
  final RxBool canResend = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    canResend.value = false;
    timerSeconds.value = AppConstants.otpTimerSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        canResend.value = true;
        t.cancel();
      }
    });
  }

  void resendOtp() {
    if (!canResend.value) return;
    _startTimer();
    // Simulate resend
  }

  Future<void> verifyOtp() async {
    if (otp.value.length != AppConstants.otpLength) return;
    isLoading.value = true;
    isError.value = false;
    await Future.delayed(const Duration(milliseconds: 1500));
    isLoading.value = false;

    // Accept any 6-digit OTP for demo
    if (otp.value == '000000') {
      isError.value = true;
    } else {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  String get timerDisplay {
    final m = timerSeconds.value ~/ 60;
    final s = timerSeconds.value % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
