import 'package:dio/dio.dart';
import '../services/assignment_service.dart';
import '../models/assignment_api_model.dart';

class AssignmentRepository {
  final AssignmentService _service = AssignmentService();

  Future<List<AssignmentApiModel>> getAssignments() async {
    try {
      final data = await _service.getAssignments();
      return (data['data'] as List)
          .map((e) => AssignmentApiModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<AssignmentApiModel> getAssignment(int id) async {
    try {
      final data = await _service.getAssignment(id);
      return AssignmentApiModel.fromJson(
          data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<AssignmentSubmission> submitAssignment(
    int id, {
    required String submissionText,
    String? filePath,
  }) async {
    try {
      final data = await _service.submitAssignment(id,
          submissionText: submissionText, filePath: filePath);
      return AssignmentSubmission.fromJson(
          data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<AssignmentSubmission> getSubmission(int submissionId) async {
    try {
      final data = await _service.getSubmission(submissionId);
      return AssignmentSubmission.fromJson(
          data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  String _parseError(DioException e) {
    if (e.error is String) return e.error as String;
    final msg = e.response?.data?['message'];
    return msg?.toString() ?? e.message ?? 'Something went wrong';
  }
}
