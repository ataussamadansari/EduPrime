import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class SupportService {
  final Dio _dio = ApiClient.instance.dio;

  /// GET /support-tickets
  Future<Map<String, dynamic>> getTickets() async {
    final res = await _dio.get('/support-tickets');
    return res.data as Map<String, dynamic>;
  }

  /// GET /support-tickets/{id}
  Future<Map<String, dynamic>> getTicket(int id) async {
    final res = await _dio.get('/support-tickets/$id');
    return res.data as Map<String, dynamic>;
  }

  /// POST /support-tickets  (multipart/form-data)
  Future<Map<String, dynamic>> createTicket({
    required String subject,
    required String message,
    required String category,
    required String priority,
    String? attachmentPath,
  }) async {
    final formData = FormData.fromMap({
      'subject': subject,
      'message': message,
      'category': category,
      'priority': priority,
      if (attachmentPath != null)
        'attachment': await MultipartFile.fromFile(attachmentPath),
    });
    final res = await _dio.post('/support-tickets', data: formData);
    return res.data as Map<String, dynamic>;
  }
}
