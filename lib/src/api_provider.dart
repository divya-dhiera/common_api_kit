import 'package:dio/dio.dart' as dio_link;

class APIProvider {
  static dio_link.Dio? _dio;
  static dio_link.BaseOptions? _options;

  static void init({
    required String baseUrl,
    int timeoutMilliseconds = 30000,
    Map<String, dynamic>? defaultHeaders,
  }) {
    _options = dio_link.BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: timeoutMilliseconds),
      receiveTimeout: Duration(milliseconds: timeoutMilliseconds),
      headers: defaultHeaders ?? {},
      validateStatus: (code) {
        if (code != null && code >= 200) {
          return true;
        }
        return false;
      },
    );
    _dio = dio_link.Dio(_options);
  }

  static dio_link.Dio getDio() {
    if (_dio == null) {
      throw Exception(
        "APIProvider not initialized. Call APIProvider.init() first.",
      );
    }
    return _dio!;
  }
}
