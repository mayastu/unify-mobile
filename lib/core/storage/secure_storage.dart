import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._();

  static const FlutterSecureStorage _storage =
  FlutterSecureStorage();

  static const String tokenKey = "token";

  //================ Save =================//

  static Future<void> saveToken(String token) async {
    await _storage.write(
      key: tokenKey,
      value: token,
    );
  }

  //================ Read =================//

  static Future<String?> getToken() async {
    return await _storage.read(
      key: tokenKey,
    );
  }

  //================ Delete =================//

  static Future<void> deleteToken() async {
    await _storage.delete(
      key: tokenKey,
    );
  }

  //================ Delete All =================//

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}