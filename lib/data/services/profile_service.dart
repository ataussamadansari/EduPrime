import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class ProfileService {
  final Dio _dio = ApiClient.instance.dio;

  Future<Map<String, dynamic>> getProfile() async {
    final res = await _dio.get('/auth/profile');
    return res.data as Map<String, dynamic>;
  }

  /// PUT /auth/profile — multipart/form-data (supports avatar image)
  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> fields, {
    String? avatarPath,
  }) async {
    final map = Map<String, dynamic>.from(fields);
    if (avatarPath != null) {
      map['avatar'] = await MultipartFile.fromFile(avatarPath);
    }
    final res = await _dio.put(
      '/auth/profile',
      data: FormData.fromMap(map),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (_) {}
  }
}
