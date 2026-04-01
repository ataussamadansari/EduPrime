import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class CertificateService {
  final Dio _dio = ApiClient.instance.dio;

  /// GET /certificates
  Future<Map<String, dynamic>> getCertificates() async {
    final res = await _dio.get('/certificates');
    return res.data as Map<String, dynamic>;
  }

  /// GET /certificates/{id}
  Future<Map<String, dynamic>> getCertificateDetail(int id) async {
    final res = await _dio.get('/certificates/$id');
    return res.data as Map<String, dynamic>;
  }
}
