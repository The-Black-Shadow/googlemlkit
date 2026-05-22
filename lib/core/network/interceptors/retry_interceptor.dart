import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  RetryInterceptor({required this.dio, this.maxRetries = 3});

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    var requestOptions = err.requestOptions;
    
    // Check if we can retry the request
    final retryCount = requestOptions.extra['retry_count'] as int? ?? 0;
    
    if (shouldRetry(err) && retryCount < maxRetries) {
      requestOptions.extra['retry_count'] = retryCount + 1;
      
      try {
        // Wait brief delay before retry
        await Future.delayed(Duration(seconds: 1 * retryCount));
        final response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      } catch (e) {
        // If retry fails, continue with error
      }
    }
    
    super.onError(err, handler);
  }

  bool shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.type == DioExceptionType.badResponse &&
            (err.response?.statusCode == 503 || err.response?.statusCode == 504));
  }
}
