abstract class ApiConsumer {
  Future<dynamic> get(
      String path, {
        Map<String, dynamic>? queryParameters,
      });

  Future<dynamic> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      });

  Future<dynamic> put(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      });


  Future<dynamic> patch(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      });

  Future<dynamic> delete(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      });

  /// Streams [url] (an absolute URL, e.g. a `file_url` from the API --
  /// not appended to [EndPoints.baseUrl]) straight to disk at
  /// [savePath] instead of buffering it as a parsed JSON body like the
  /// other methods. [onReceiveProgress] reports (bytesReceived,
  /// totalBytes) as the download runs.
  Future<void> download(
      String url,
      String savePath, {
        void Function(int received, int total)? onReceiveProgress,
      });
}
