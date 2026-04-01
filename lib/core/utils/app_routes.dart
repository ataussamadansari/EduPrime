import 'package:get/get.dart';
import '../../modules/splash/splash_screen.dart';
import '../../modules/onboarding/onboarding_screen.dart';
import '../../modules/auth/login/login_screen.dart';
import '../../modules/auth/otp/otp_screen.dart';
import '../../modules/home/home_screen.dart';
import '../../modules/course_detail/course_detail_screen.dart';
import '../../modules/admission/admission_screen.dart';
import '../../modules/admission/payment_screen.dart';
import '../../modules/admission/payment_success_screen.dart';

const _duration = Duration(milliseconds: 300);

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String courseDetail = '/course-detail';
  static const String admission = '/admission';
  static const String payment = '/payment';
  static const String paymentSuccess = '/payment-success';

  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: _duration,
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
      transition: Transition.fadeIn,
      transitionDuration: _duration,
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: _duration,
    ),
    GetPage(
      name: otp,
      page: () => const OtpScreen(),
      transition: Transition.fadeIn,
      transitionDuration: _duration,
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: _duration,
    ),
    GetPage(
      name: courseDetail,
      page: () => const CourseDetailScreen(),
      transition: Transition.fadeIn,
      transitionDuration: _duration,
    ),
    GetPage(
      name: admission,
      page: () => const AdmissionScreen(),
      transition: Transition.fadeIn,
      transitionDuration: _duration,
    ),
    GetPage(
      name: payment,
      page: () => const PaymentScreen(),
      transition: Transition.fadeIn,
      transitionDuration: _duration,
    ),
    GetPage(
      name: paymentSuccess,
      page: () => const PaymentSuccessScreen(),
      transition: Transition.fadeIn,
      transitionDuration: _duration,
    ),
  ];
}
