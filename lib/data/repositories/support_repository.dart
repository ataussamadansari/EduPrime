import 'package:dio/dio.dart';
import '../services/support_service.dart';
import '../models/support_ticket_model.dart';

class SupportRepository {
  final SupportService _service = SupportService();

  Future<List<SupportTicketModel>> getTickets() async {
    try {
      final data = await _service.getTickets();
      return (data['data'] as List)
          .map((e) => SupportTicketModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<SupportTicketModel> getTicket(int id) async {
    try {
      final data = await _service.getTicket(id);
      return SupportTicketModel.fromJson(
          data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<SupportTicketModel> createTicket({
    required String subject,
    required String message,
    required String category,
    required String priority,
    String? attachmentPath,
  }) async {
    try {
      final data = await _service.createTicket(
        subject: subject,
        message: message,
        category: category,
        priority: priority,
        attachmentPath: attachmentPath,
      );
      return SupportTicketModel.fromJson(
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
