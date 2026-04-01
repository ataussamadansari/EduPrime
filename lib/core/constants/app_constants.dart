import 'package:flutter_dotenv/flutter_dotenv.dart';

// App-wide constants
class AppConstants {
  static const String appName = 'EduPrime';

  // API — loaded from .env file
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://ssvv.aradhyatech.com/api/v1';
  static const String appTagline = 'Learn. Grow. Succeed.';

  // Spacing (8pt grid)
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // Border radius
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 28.0;
  static const double radiusFull = 100.0;

  // Animation durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 600);

  // OTP
  static const int otpLength = 6;
  static const int otpTimerSeconds = 60;
}
