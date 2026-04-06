import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../../core/network/api_client.dart';

class AuthRepository {
  final AuthService _service = AuthService();
  final _box = GetStorage();

  static const _tokenKey = 'auth_token';

  /// Returns otp_sent status. In dev the OTP is also returned by API.
  Future<({bool otpSent, String? otp, String? expiresAt, String? message})>
      sendOtp(String mobile) async {
    try {
      final data = await _service.sendOtp(mobile);
      final d = data['data'] as Map<String, dynamic>;
      return (
        otpSent: d['otp_sent'] as bool,
        otp: d['otp']?.toString(),
        expiresAt: d['expires_at']?.toString(),
        message: data['message']?.toString(),
      );
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  /// Returns [UserModel] and persists token on success.
  Future<UserModel> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    try {
      final data = await _service.verifyOtp(mobile: mobile, otp: otp);
      final d = data['data'] as Map<String, dynamic>;
      final token = d['token']?.toString() ?? '';

      if (token.isEmpty) {
        throw 'Authentication failed. No token received.';
      }

      // Persist token — synchronous, no await needed
      _box.write(_tokenKey, token);

      // Attach to future requests
      ApiClient.instance.setAuthToken(token);

      return UserModel.fromJson(d['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  String? getSavedToken() => _box.read<String>(_tokenKey);

  void logout() {
    _box.remove(_tokenKey);
    ApiClient.instance.clearAuthToken();
  }

  String _parseError(DioException e) {
    if (e.error is String) return e.error as String;
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return e.message ?? 'Something went wrong';
  }
}
