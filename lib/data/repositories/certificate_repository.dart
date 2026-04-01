import 'package:dio/dio.dart';
import '../services/certificate_service.dart';
import '../models/certificate_model.dart';

class CertificateRepository {
  final CertificateService _service = CertificateService();

  Future<List<CertificateModel>> getCertificates() async {
    try {
      final data = await _service.getCertificates();
      return (data['data'] as List)
          .map((e) => CertificateModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<CertificateModel> getCertificateDetail(int id) async {
    try {
      final data = await _service.getCertificateDetail(id);
      return CertificateModel.fromJson(data['data'] as Map<String, dynamic>);
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
