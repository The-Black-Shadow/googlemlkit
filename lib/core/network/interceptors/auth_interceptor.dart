import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if present
    options.headers['Authorization'] = 'Bearer dummy_token';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle token expiration or unauthorized errors
    if (err.response?.statusCode == 401) {
      // In a real app, trigger a token refresh or logout
    }
    super.onError(err, handler);
  }
}
