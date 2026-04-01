import 'package:dio/dio.dart';
import '../services/profile_service.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class ProfileRepository {
  final ProfileService _service = ProfileService();
  final AuthRepository _authRepo = AuthRepository();

  Future<UserModel> getProfile() async {
    try {
      final data = await _service.getProfile();
      return UserModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<UserModel> updateProfile(Map<String, dynamic> fields,
      {String? avatarPath}) async {
    try {
      final data = await _service.updateProfile(fields, avatarPath: avatarPath);
      return UserModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<void> logout() async {
    await _service.logout();
    _authRepo.logout(); // clears token from storage + ApiClient
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
