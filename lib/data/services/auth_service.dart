import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class AuthService {
  final Dio _dio = ApiClient.instance.dio;

  /// POST /auth/send-otp
  Future<Map<String, dynamic>> sendOtp(String mobile) async {
    final res = await _dio.post('/auth/send-otp', data: {'mobile': mobile});
    return res.data as Map<String, dynamic>;
  }

  /// POST /auth/verify-otp
  Future<Map<String, dynamic>> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    final res = await _dio.post(
      '/auth/verify-otp',
      data: {'mobile': mobile, 'otp': otp},
    );
    return res.data as Map<String, dynamic>;
  }
}
