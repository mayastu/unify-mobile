class ServerException implements Exception {

  final String message;

  ServerException(this.message);

}

class TimeoutException implements Exception {}

class NoInternetException implements Exception {}