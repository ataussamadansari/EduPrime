import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import '../constants/app_constants.dart';
import '../utils/app_routes.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  )..interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      _AuthInterceptor(),
    ]);

  Dio get dio => _dio;

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

class _AuthInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final message = _extractMessage(err);

    if (status == 401) {
      // Clear token and redirect to login
      GetStorage().remove('auth_token');
      ApiClient.instance.clearAuthToken();
      // Use Get.offAllNamed only if a context is available
      if (Get.isRegistered() || Get.key.currentContext != null) {
        Get.offAllNamed(AppRoutes.login);
      }
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          error: 'Session expired. Please login again.',
        ),
      );
      return;
    }

    if (status == 403) {
      handler.reject(DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: message ?? 'Access denied.',
      ));
      return;
    }

    if (status == 422) {
      // Collect validation errors into a readable string
      String errorMsg = message ?? 'Validation error.';
      try {
        final errors = err.response?.data?['errors'];
        if (errors is Map) {
          errorMsg = errors.values
              .expand((v) => v is List ? v : [v])
              .join('\n');
        }
      } catch (_) {}
      handler.reject(DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: errorMsg,
      ));
      return;
    }

    if (status == 404) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          error: message ?? 'Resource not found.',
        ),
      );
      return;
    }

    // For all other errors, pass the API message if available
    if (message != null) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          error: message,
        ),
      );
      return;
    }

    handler.next(err);
  }

  String? _extractMessage(DioException err) {
    try {
      final data = err.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
    } catch (_) {}
    return null;
  }
}
