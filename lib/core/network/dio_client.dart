import 'package:dio/dio.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

class DioClient {
  final Dio dio;

  DioClient() : dio = Dio() {
    dio.options
      ..baseUrl = 'https://api.dummy.com'
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 15)
      ..headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

    dio.interceptors.addAll([
      AuthInterceptor(),
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
      RetryInterceptor(dio: dio),
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // Implement queued token refresh when 401 Unauthorized is encountered
          if (error.response?.statusCode == 401) {
            // In a real application, perform queued refresh logic here
          }
          return handler.next(error);
        },
      ),
    ]);
  }
}
