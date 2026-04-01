import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class AssignmentService {
  final Dio _dio = ApiClient.instance.dio;

  Future<Map<String, dynamic>> getAssignments() async {
    final res = await _dio.get('/assignments');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAssignment(int id) async {
    final res = await _dio.get('/assignments/$id');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> submitAssignment(
    int id, {
    required String submissionText,
    String? filePath,
  }) async {
    final formData = FormData.fromMap({
      'submission_text': submissionText,
      if (filePath != null)
        'file': await MultipartFile.fromFile(filePath),
    });
    final res = await _dio.post('/assignments/$id/submit', data: formData);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSubmission(int submissionId) async {
    final res = await _dio.get('/assignment-submissions/$submissionId');
    return res.data as Map<String, dynamic>;
  }
}
