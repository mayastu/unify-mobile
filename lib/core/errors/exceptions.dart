class ServerException implements Exception {

  final String message;

  ServerException(this.message);

  @override
  String toString() => message;

}

class TimeoutException implements Exception {}

class NoInternetException implements Exception {}