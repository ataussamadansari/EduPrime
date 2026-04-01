import 'dart:async';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_routes.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';

class OtpController extends GetxController {
  final RxString otp = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorText = ''.obs;
  final RxInt timerSeconds = AppConstants.otpTimerSeconds.obs;
  final RxBool canResend = false.obs;

  late final String mobile;
  String? _devOtp; // pre-filled in dev from API response

  Timer? _timer;
  final _repo = AuthRepository();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    mobile = args?['mobile'] ?? '';
    _devOtp = args?['otp'];
    if (_devOtp != null) otp.value = _devOtp!; // auto-fill for dev
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

  Future<void> resendOtp() async {
    if (!canResend.value) return;
    try {
      final result = await _repo.sendOtp(mobile);
      _devOtp = result.otp;
      _startTimer();
    } catch (e) {
      errorText.value = e.toString();
    }
  }

  Future<void> verifyOtp() async {
    if (otp.value.length != AppConstants.otpLength) return;
    isLoading.value = true;
    errorText.value = '';
    try {
      final UserModel user = await _repo.verifyOtp(
        mobile: mobile,
        otp: otp.value,
      );
      // Store user in GetX for app-wide access
      Get.put(user, permanent: true);
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      errorText.value = e.toString();
    } finally {
      isLoading.value = false;
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
