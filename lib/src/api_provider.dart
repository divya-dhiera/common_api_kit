import 'package:dio/dio.dart' as dio_link;

/// A utility class for initializing and providing a singleton [Dio] instance
/// with custom base URLs, timeouts, and headers.

class APIProvider {
  static dio_link.Dio? _dio;
  static dio_link.BaseOptions? _options;

  /// Initializes the global [Dio] instance with the specified [baseUrl],
  /// [timeoutMilliseconds], and [defaultHeaders].

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

    /// Returns the initialized [Dio] instance. Throws an exception if [init] was not called.
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
